module Pump
  class Application < WEBrick::HTTPServlet::AbstractServlet
    attr_reader :socket_path, :app_path

    def self.get_instance(server, *options)
      Pump.logger "Getting instance of application"
      @@app ||= new(server, *options)
    end

    def initialize(server, app_path)
      super server
      @app_path, @socket_path = app_path, File.join(PUMP_ROOT, "var", "run", "#{File.basename(app_path)}.sock")
      fork_app
    end

    def service(req, res)
      Pump.logger "Incoming request"
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
      Pump.logger "Application response"

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

    def fork_app
      Pump.logger "Forking new application"
      fork do
        args = Pump.pumpup_path, app_path, socket_path
        if defined?(RVM)
          rvm_string = RVM.tools.path_identifier(app_path)
          RVM::Environment.new(rvm_string).exec(args)
        else
          exec(args)
        end
      end
      check_socket
    end

    def check_socket
      # TODO Is there another way to check socket existence?
      5.times do |i|
        Pump.logger "Attempt to check socket existence ##{i}"
        break if File.exist?(socket_path)
        sleep 2
      end
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
