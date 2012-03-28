module Pump
  class AbstractApplication < WEBrick::HTTPServlet::AbstractServlet
    attr_reader :socket_path, :app_path

    def self.get_instance(server, *options)
      Pump.logger "Getting instance of application"
      @@app ||= new(server, *options)
    end

    def initialize(server, app_path)
      super server
      @app_path, @socket_path = app_path, File.join(PUMP_ROOT, "var", "run", "#{File.basename(app_path)}.sock")
      @semaphore = Mutex.new
      fork_app
    end

    def service(req, res)
      @semaphore.synchronize do
        Pump.logger "Incoming request"
        fork_app unless File.exist?(socket_path)
        socket = UNIXSocket.open(socket_path)

        env = req.meta_vars
        env["HTTP_VERSION"] ||= env["SERVER_PROTOCOL"]
        env["QUERY_STRING"] ||= ""
        unless env["PATH_INFO"] == ""
          path, n = req.request_uri.path, env["SCRIPT_NAME"].length
          env["PATH_INFO"] = path[n, path.length-n]
        end
        env["REQUEST_PATH"] ||= [env["SCRIPT_NAME"], env["PATH_INFO"]].join

        socket.send Marshal.dump(env), 0

        status, headers, body = Marshal.load recvall(socket)
        Pump.logger "AbstractApplication response"

        res.status = status
        headers.each do |k, vs|
          if k.downcase == "set-cookie"
            res.cookies.concat vs.split("\n")
          else
            # Since WEBrick won't accept repeated headers,
            # merge the values per RFC 1945 section 4.2.
            res[k] = vs.split("\n").join(", ")
          end
        end
        res.body = body

        socket.close
      end
    end

    def fork_app
      Pump.logger "Creating #{socket_path} socket"
      server_socket = UNIXServer.new(socket_path)

      Pump.logger "Forking new application"
      fork do
        args = Pump.pumpup_path, app_path, server_socket.fileno, socket_path
        if defined?(RVM)
          rvm_string = RVM.tools.path_identifier(app_path)
          RVM::Environment.new(rvm_string).exec(args)
        else
          exec(args)
        end
      end

      server_socket.close
    end

    def recvall(socket)
      str = ""
      loop do
        data, info = socket.recvfrom(512)
        str << data
        break if data.empty? || IO.select([socket], nil, nil, 0).nil?
      end
      str
    end
  end
end
