module Pump
  class Install::RackHTTP < Launchctl
    def self.service_name
      "rackhttpd"
    end
  end
end
