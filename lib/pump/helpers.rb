module Pump
  module Helpers
    def mac?
      !!(RUBY_PLATFORM =~ /darwin/)
    end

    # Get pump path from rvm bin directory if we used rvm wrapper
    def pump_path
      defined?(RVM) ? wrapper_path : %x(which pump)
    end

    # Check superuser privileges
    def superuser_rights?
      [Process.uid, Process.euid] == [0, 0]
    end

    # Drop superuser privilege temporarily
    def grant_privilege
      Process::UID.grant_privilege(ENV["SUDO_UID"].to_i)
      yield
      Process::UID.grant_privilege(0)
    end

    # Drop superuser privilege permanently
    def drop_privilege
      Process::UID.change_privilege(ENV["SUDO_UID"].to_i)
    end

    def wrapper_path
      File.join(RVM::Environment.rvm_bin_path, "pump")
    end

    def sudo
      defined?(RVM) ? "rvmsudo" : "sudo"
    end
  end
end
