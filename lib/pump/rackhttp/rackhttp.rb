require 'webrick'

module Pump
  class RackHTTP < WEBrick::HTTPServer
    def lookup_server(req)
      Pump.logger "Lookup responsible server"
      mount_application req.host
      super
    end

    def mount_application(domain)
      Pump.logger "Trying to mount application"
      domain, path = Settings.find_by_domain(domain)
      return if domain.nil? || path.nil? || mounted_application?(domain)
      vhost = WEBrick::HTTPServer.new :ServerName => domain.to_s, :DoNotListen => true
      vhost.mount '/', Pump::Application, path
      virtual_host vhost
      Pump.logger "Mounted #{domain} application"
    end

    def mounted_application?(domain)
      @virtual_hosts.find { |s| s[:ServerName] == domain.to_s }
    end
  end
end
