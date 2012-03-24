module Pump
  module Launchctl
    # Load configuration files
    def self.load(plist)
      invoke("launchctl", "load", "-w", plist)
    end

    # Unload configuration files
    def self.unload(plist)
      invoke("launchctl", "unload", "-w", plist)
    end
    
    # Start specified job
    def self.start(name)
      invoke("launchctl", "start", name)
    end

    # Stop specified job
    def self.stop(name)
      invoke("launchctl", "stop", name)
    end

    def self.invoke(*args)
      unless system(*args)
        abort("launchctl(pid = #{$?.pid}) exited with status: #{$?.exitstatus}")
      end
    end
  end
end
