require "pump/settings"

module Pump
  class Install::MasqDNS < Launchctl
    RESOLVER_PATH = "/etc/resolver"
    CONFIG = File.join(PUMP_ROOT, "config", "masqdns.conf")

    def self.service_name
      "masqdnsd"
    end

    def self.install
      create_resolvers
      super
    end

    def self.uninstall
      remove_resolvers
      super
    end

    def self.resolvers
      Settings.first_level_domains.each do |domain|
        yield File.join(RESOLVER_PATH, domain)
      end
    end

    def self.create_resolvers
      create_resolver_dir
      resolvers do |resolver|
        unless File.exist?(resolver)
          FileUtils.cp(CONFIG, resolver)
          debug "Resolver #{resolver} was created."
        end
      end
    end

    def self.remove_resolvers
      resolvers do |resolver|
        if File.exist?(resolver)
          FileUtils.rm(resolver)
          debug "Resolver #{resolver} was removed."
        end
      end
    end

    def self.create_resolver_dir
      FileUtils.mkdir(RESOLVER_PATH) unless File.exist?(RESOLVER_PATH)
    end
  end
end
