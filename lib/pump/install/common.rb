require 'pump/install/launchctl'

module Pump
  USER_PLIST_DIR = File.join(ENV["HOME"], "Library/LaunchAgents")

  module Install
    module Common
      def self.install
        Pump.switch_privileges {
          mkdir_config
          mkdir_plist
          create_rvm_wrapper if defined?(RVM)
        }
      end

      def self.uninstall
        Pump.switch_privileges {
          # TODO: Delete with confirm
          # FileUtils.mkdir(USER_CONFIG_DIR) unless File.exist?(USER_CONFIG_DIR)
          remove_rvm_wrapper if defined?(RVM)
        }
      end

      def self.create_rvm_wrapper
        RVM.wrapper RVM.current.environment_name, "--no-prefix", "pump"
      end

      def self.remove_rvm_wrapper
        FileUtils.rm(Pump.pump_path) if File.exist?(Pump.pump_path)
      end

      def self.mkdir_plist
        FileUtils.mkdir_p(USER_PLIST_DIR) unless File.exist?(USER_PLIST_DIR)
      end

      def self.mkdir_config
        FileUtils.mkdir(USER_CONFIG_DIR) unless File.exist?(USER_CONFIG_DIR)
      end
    end
  end
end
