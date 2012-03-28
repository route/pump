require 'fileutils'
require 'pump/helpers'

module Pump
  module Install
    def self.install
      # TODO: Add linux support
      abort("Currently only macs sorry.") unless Pump.mac?

      Pump.switch_privileges do
        mkdir_config
        create_rvm_wrapper if defined?(RVM)
      end

      if Pump.mac?
        dependencies(:install)
      else
        raise "Support only for mac now."
      end
    end

    def self.uninstall
      # TODO: Add linux support
      abort("Currently only macs sorry.") unless Pump.mac?

      if Pump.mac?
        dependencies(:uninstall)
      else
        raise "Support only for mac now."
      end

      Pump.switch_privileges do
        rmdir_config
        remove_rvm_wrapper if defined?(RVM)
      end
    end

    def self.create_rvm_wrapper
      RVM.wrapper RVM.current.environment_name, "--no-prefix", "pump"
    end

    def self.remove_rvm_wrapper
      FileUtils.rm(Pump.pump_path) if File.exist?(Pump.pump_path)
    end

    def self.mkdir_config
      FileUtils.mkdir(USER_CONFIG_DIR) unless File.exist?(USER_CONFIG_DIR)
    end

    def self.rmdir_config
      print "Remove config directory #{USER_CONFIG_DIR} (y/n)? "
      FileUtils.rm_rf(USER_CONFIG_DIR) if STDIN.gets.strip == 'y' && File.exist?(USER_CONFIG_DIR)
    end

    def self.dependencies(action)
      platform = Pump.mac? ? "mac" : "unix"
      require "pump/install/#{platform}/launchctl" if Pump.mac?
      require "pump/install/#{platform}/masqdns"
      require "pump/install/#{platform}/rackhttp"
      require "pump/install/#{platform}/firewall"

      [MasqDNS, Firewall, RackHTTP].each(&action)
    end
  end
end
