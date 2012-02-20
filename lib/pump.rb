require 'fileutils'
require 'erb'

require 'pump/rvm'
require 'pump/helpers'
require 'pump/settings'
require 'pump/masqdns'
require 'pump/masqdns/names'
require 'pump/masqdns/server'
require 'pump/version'

module Pump
  PUMP_ROOT = File.expand_path("../../", __FILE__)
  USER_PLIST_DIR = File.join(ENV["HOME"], "Library/LaunchAgents")
  MASQDNS_PLIST = File.join(PUMP_ROOT, "config", "com.github.pump.masqdnsd.plist.erb")
  MASQDNS_USER_PLIST = File.join(USER_PLIST_DIR, "com.github.pump.masqdnsd.plist")

  extend Helpers

  # Run masqdns server
  def self.masqdns
    MasqDNS.new "127.0.0.1", 11253
  end

  def self.install
    MasqDNS.install
    # Firewall.install
    # RackHttp.install
  end

  def self.uninstall
    MasqDNS.uninstall
    # Firewall.uninstall
    # RackHttp.uninstall
  end
end
