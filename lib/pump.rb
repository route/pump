require 'pump/helpers'
require 'pump/settings'

require 'pump/masqdns/masqdns'

require 'pump/rackhttp/rackhttp'
require 'pump/rackhttp/abstract_application'

module Pump
  # Run masqdns server
  def self.masqdnsd
    $0 = "masqdnsd"
    MasqDNS.new "127.0.0.1", 11253
  end

  # Run rackhttp server
  def self.rackhttpd
    $0 = "rackhttpd"
    RackHTTP.new "127.0.0.1", 11280
  end
end
