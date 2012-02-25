require "logger"

module Pump
  module Helpers
    def mac?
      !!(RUBY_PLATFORM =~ /darwin/)
    end

    # Get pump path from rvm bin directory if we used rvm wrapper
    def pump_path
      defined?(RVM) ? wrapper_path : %x(which pump)
    end

    # Get pumpup path to run rack application
    def pumpup_path
      File.join(PUMP_ROOT, "bin", "pumpup")
    end

    # Check superuser privileges
    def superuser_rights?
      [Process.uid, Process.euid] == [0, 0]
    end

    # Switch superuser privileges
    def switch_privileges
      Process.uid, Process.gid = ENV["SUDO_UID"].to_i, ENV["SUDO_GID"].to_i
      Process::UID.switch {
        Process::GID.switch {
          yield
        }
      }
    end

    def wrapper_path
      File.join(RVM::Environment.rvm_bin_path, "pump")
    end

    def sudo
      defined?(RVM) ? "rvmsudo" : "sudo"
    end

    def logger
      @@logger ||= Logger.new(STDERR)
    end
  end
end
