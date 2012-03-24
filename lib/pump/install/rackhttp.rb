module Pump
  module Install
    module RackHTTP
      SERVICE_NAME = "rackhttpd"
      RACKHTTP_USER_PLIST = File.join(USER_PLIST_DIR, "com.github.pump.%s.plist") % SERVICE_NAME

      def self.install
        Pump.switch_privileges {
          create_rackhttp_plist
          Launchctl.load(RACKHTTP_USER_PLIST)
        }
      end

      def self.uninstall
        Pump.switch_privileges {
          Launchctl.stop("com.github.pump.rackhttpd")
          Launchctl.unload(RACKHTTP_USER_PLIST)
          remove_rackhttp_plist
        }
      end

      def self.create_rackhttp_plist
        config = ERB.new File.read(PLIST)
        template = config.result(binding)
        File.open(RACKHTTP_USER_PLIST, "w") do |file|
          file.write template
        end
      end

      def self.remove_rackhttp_plist
        FileUtils.rm(RACKHTTP_USER_PLIST) if File.exist?(RACKHTTP_USER_PLIST)
      end
    end
  end
end
