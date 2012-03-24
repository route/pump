require 'fileutils'
require 'erb'

require 'pump/rvm'
require 'pump/helpers'
require 'pump/settings'

require 'pump/install/common'
require 'pump/install/masqdns'
require 'pump/install/rackhttp'
require 'pump/install/firewall'

require 'pump/masqdns/names'
require 'pump/masqdns/masqdns'

require 'pump/rackhttp/rackhttp'
require 'pump/rackhttp/abstract_application'

require 'pump/version'

module Pump
  PUMP_ROOT = File.expand_path("../../", __FILE__)
  PLIST = File.join(PUMP_ROOT, "config", "com.github.pump.plist.erb")

  extend Helpers

  # Run masqdns server
  def self.masqdnsd
    $0 = "masqdnsd"
    MasqDNS.new "127.0.0.1", 11253
  end

  # Run rackhttp server
  def self.rackhttpd
    $0 = "rackhttpd"

    server = RackHTTP.new(
      :BindAddress => "127.0.0.1",
      :Port => 11280,
      :DocumentRoot => File.join(PUMP_ROOT, "public"),
      :Logger => WEBrick::Log.new('/dev/null')
    )

    trap(:INT) { server.shutdown }
    trap(:TERM) { server.shutdown }

    server.start
  end
end
