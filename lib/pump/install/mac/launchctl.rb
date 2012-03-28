require 'erb'

module Pump
  class Launchctl
    PLIST_DIR = File.join(ENV["HOME"], "Library/LaunchAgents")
    SERVICE_NAME_TEMPLATE = "com.github.pump.%s"
    PLIST = File.join(PLIST_DIR, "#{SERVICE_NAME_TEMPLATE}.plist")
    PLIST_TEMPLATE = File.join(PUMP_ROOT, "config", "#{SERVICE_NAME_TEMPLATE}.plist.erb")

    class Base
      class << self
        # Load configuration files
        def load(plist)
          invoke("launchctl", "load", "-w", plist)
        end

        # Unload configuration files
        def unload(plist)
          invoke("launchctl", "unload", "-w", plist)
        end

        # Start specified job
        def start(name)
          invoke("launchctl", "start", name)
        end

        # Stop specified job
        def stop(name)
          invoke("launchctl", "stop", name)
        end

        def invoke(*args)
          system(*args)
          # unless system(*args)
          #   abort("launchctl(pid = #{$?.pid}) exited with status: #{$?.exitstatus}")
          # end
        end
      end
    end

    class << self
      def service_name
        raise "You should specify service_name in your class"
      end

      def install
        mkdir_plist
        Pump.switch_privileges do
          create_plist
          Base.load(self::PLIST % service_name)
        end
      end

      def uninstall
        Pump.switch_privileges do
          Base.stop(self::SERVICE_NAME_TEMPLATE % service_name)
          Base.unload(self::PLIST % service_name)
          remove_plist
        end
      end

      def create_plist
        config = ERB.new File.read(self::PLIST_TEMPLATE % service_name)
        Pump.logger "Open plist template #{self::PLIST_TEMPLATE % service_name}"
        template = config.result(binding)
        Pump.logger "Write plist #{self::PLIST % service_name}"
        File.open(self::PLIST % service_name, "w") do |file|
          file.write template
        end
      end

      def remove_plist
        if File.exist?(self::PLIST % service_name)
          Pump.logger "Remove plist #{self::PLIST % service_name}"
          FileUtils.rm(self::PLIST % service_name)
        end
      end

      def mkdir_plist
        FileUtils.mkdir_p(self::PLIST_DIR) unless File.exist?(self::PLIST_DIR)
      end
    end
  end
end
