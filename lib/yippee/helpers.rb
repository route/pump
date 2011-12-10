module Yippee
  module Helpers
    def mac?
      !!(RUBY_PLATFORM =~ /darwin/)
    end

    # Get yippee path from rvm bin directory if we used rvm wrapper
    # TODO check for system and remove %x
    def yippee_command
      using_rvm? ? File.join(ENV["rvm_bin_path"], "yippee") : %x(which yippee)
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

    def using_rvm?
      ENV["rvm_ruby_string"] && ENV["rvm_ruby_string"] != "system"
    end

    # Return sudo command name, it is different for rvm and system mode
    def sudo
      using_rvm? ? "rvmsudo" : "sudo"
    end
  end
end
