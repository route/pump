module Pump
  class MasqDNS
    def self.install
      FileUtils.mkdir(USER_CONFIG_DIR) unless File.exist?(USER_CONFIG_DIR)
      create_masqdns_resolvers
      Pump.grant_privilege { create_masqdns_plist }
      Pump.drop_privilege
      create_rvm_wrapper
      load_masqdns_plist
    end

    def self.uninstall
      # TODO: Delete with confirm
      # FileUtils.mkdir(USER_CONFIG_DIR) unless File.exist?(USER_CONFIG_DIR)
      remove_masqdns_resolvers
      Pump.drop_privilege
      stop_masqdns
      unload_masqdns_plist
      remove_masqdns_plist
      remove_rvm_wrapper
    end

    def self.create_masqdns_resolvers
      config = File.join(PUMP_ROOT, "config/masqdns.conf")
      resolver = "/etc/resolver/%s"
      Settings.first_level_domains.each do |domain|
        unless File.exist?(resolver % domain)
          FileUtils.cp(config, resolver % domain)
          puts "Resolver for #{domain} was created."
        end
      end
    end

    def self.create_masqdns_plist
      mkdir_p(USER_PLIST_DIR) unless File.exist?(USER_PLIST_DIR)
      config = ERB.new File.read(MASQDNS_PLIST)
      File.open(MASQDNS_USER_PLIST, "w") { |file| file.write(config.result) }
    end

    def self.create_rvm_wrapper
      if defined?(RVM)
        RVM.wrapper RVM.current.environment_name, "--no-prefix", "pump"
      end
    end

    def self.remove_rvm_wrapper
      FileUtils.rm(Pump.pump_path) if defined?(RVM)
    end

    def self.load_masqdns_plist
      %x(launchctl load -w #{MASQDNS_USER_PLIST})
    end

    def self.unload_masqdns_plist
      %x(launchctl unload -w #{MASQDNS_USER_PLIST})
    end

    def self.stop_masqdns
      %x(launchctl stop com.github.pump.masqdnsd)
    end

    def self.remove_masqdns_plist
      FileUtils.rm(MASQDNS_USER_PLIST)
    end

    def self.remove_masqdns_resolvers
      FileUtils.rm("/etc/resolver/pump")
    end
  end
end
