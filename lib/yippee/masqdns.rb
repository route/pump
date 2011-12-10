module Yippee
  class MasqDNS
    def self.install
      if Yippee.mac?
        FileUtils.mkdir(USER_CONFIG_DIR) unless File.exist?(USER_CONFIG_DIR)
        create_masqdns_resolvers
        Yippee.grant_privilege { create_masqdns_plist }
        Yippee.drop_privilege
        load_masqdns_plist
        create_rvm_wrapper if Yippee.using_rvm?
      else
        abort "Currently support only Mac OS platform"
      end
    end

    def self.uninstall
      if Yippee.mac?
        # TODO: Delete with confirm
        # FileUtils.mkdir(USER_CONFIG_DIR) unless File.exist?(USER_CONFIG_DIR)
        remove_masqdns_resolvers
        Yippee.drop_privilege
        stop_masqdns
        unload_masqdns_plist
        remove_masqdns_plist
        remove_rvm_wrapper if Yippee.using_rvm?
      end
    end

    def self.create_masqdns_resolvers
      config = File.join(YIPPEE_ROOT, "config/masqdns.conf")
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
      %x(rvm wrapper #{ENV["rvm_ruby_string"]} --no-prefix yippee)
    end

    def self.load_masqdns_plist
      %x(launchctl load -w #{MASQDNS_USER_PLIST})
    end

    def self.stop_masqdns
      %x(launchctl stop com.github.yippee.masqdnsd)
    end

    def self.unload_masqdns_plist
      %x(launchctl unload -w #{MASQDNS_USER_PLIST})
    end

    def self.remove_masqdns_plist
      FileUtils.rm(MASQDNS_USER_PLIST)
    end

    def self.remove_masqdns_resolvers
      FileUtils.rm("/etc/resolver/yippee")
    end

    def self.remove_rvm_wrapper
      FileUtils.rm(Yippee.yippee_command)
    end
  end
end
