require 'webrick'

module Pump
  class RackHTTP
    @@config = WEBrick::Config::HTTP

    def initialize(address, port)
      @server = TCPServer.new(address, port)
      handle_requests
    end

    def handle_requests
      loop do
        client = @server.accept
        req, res = WEBrick::HTTPRequest.new(@@config), WEBrick::HTTPResponse.new(@@config)
        req.parse(client)

        debug "Request: #{req.unparsed_uri}"

        if app = lookup_server(req)
          app.service(req, res)
        else
          res.status = 200
          res.body = "Rack server not found."
        end

        client.send res.to_s, 0
        client.close

        debug "Answer #{res.object_id} sent."
      end
    end

    def lookup_server(req)
      debug "Lookup responsible server"
      domain, path = Settings.find_by_domain(req.host)
      Pump::AbstractApplication.get_instance(path) if path
    end
  end
end
