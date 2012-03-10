module Pump
  module Install
    module MasqDNS
      SERVICE_NAME = "masqdnsd"
      MASQDNS_USER_PLIST = File.join(USER_PLIST_DIR, "com.github.pump.%s.plist") % SERVICE_NAME

      def self.install
        create_masqdns_resolvers
        Pump.switch_privileges {
          create_masqdns_plist
          load_masqdns_plist
        }
      end

      def self.uninstall
        remove_masqdns_resolvers
        Pump.switch_privileges {
          stop_masqdns
          unload_masqdns_plist
          remove_masqdns_plist
        }
      end

      def self.create_masqdns_resolvers
        resolver_path = "/etc/resolver"
        FileUtils.mkdir(resolver_path) unless File.exist?(resolver_path)
        config = File.join(PUMP_ROOT, "config/masqdns.conf")
        Settings.first_level_domains.each do |domain|
          resolver = File.join(resolver_path, domain)
          unless File.exist?(resolver)
            FileUtils.cp(config, resolver)
            puts "Resolver for #{domain} was created."
          end
        end
      end

      def self.create_masqdns_plist
        config = ERB.new File.read(PLIST)
        template = config.result(binding)
        File.open(MASQDNS_USER_PLIST, "w") do |file|
          file.write template
        end
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
        FileUtils.rm(MASQDNS_USER_PLIST) if File.exist?(MASQDNS_USER_PLIST)
      end

      def self.remove_masqdns_resolvers
        FileUtils.rm("/etc/resolver/pump") if File.exist?("/etc/resolver/pump")
      end
    end
  end
end
