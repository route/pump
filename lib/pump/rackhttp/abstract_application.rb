module Pump
  class AbstractApplication
    attr_reader :socket_path, :app_path

    def self.get_instance(app_path)
      @@apps ||= Hash.new
      @@apps[app_path] ||= new(app_path)
      debug "Got instance of application #{app_path}"
      @@apps[app_path]
    end

    def initialize(app_path)
      @app_path, @socket_path = app_path, File.join(PUMP_ROOT, "var", "run", "#{File.basename(app_path)}.sock")
      fork_app
    end

    def service(req, res)
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
      env["body"] = req.body.to_s

      socket.send Marshal.dump(env), 0

      data = receive_data(socket)
      debug "Response size: #{data.size}"

      status, headers, body = Marshal.load(data)

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
    end

    def fork_app
      debug "Creating #{socket_path} socket"
      server_socket = UNIXServer.new(socket_path)

      debug "Forking new application"
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

    def receive_data(socket, buffer = "")
      loop do
        part = socket.recv(1024)
        break if part.empty?
        buffer << part
      end
      buffer
    end
  end
end
