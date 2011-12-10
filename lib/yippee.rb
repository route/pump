require 'fileutils'
require 'erb'

require 'yippee/helpers'
require 'yippee/settings'
require 'yippee/masqdns'
require 'yippee/masqdns/names'
require 'yippee/masqdns/server'
require 'yippee/version'

module Yippee
  YIPPEE_ROOT = File.expand_path("../../", __FILE__)
  USER_PLIST_DIR = File.join(ENV["HOME"], "Library/LaunchAgents")
  MASQDNS_PLIST = File.join(YIPPEE_ROOT, "config", "com.github.yippee.masqdnsd.plist.erb")
  MASQDNS_USER_PLIST = File.join(USER_PLIST_DIR, "com.github.yippee.masqdnsd.plist")

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
