module Pump
  class Install::Firewall < Launchctl
    PLIST_DIR = "/Library/LaunchDaemons"
    PLIST = File.join(PLIST_DIR, "#{SERVICE_NAME_TEMPLATE}.plist")

    def self.service_name
      "firewall"
    end

    # Create and load plist under root
    def self.install
      mkdir_plist
      create_plist
      Base.load(PLIST % service_name)
    end

    # Unload and remove plist under root
    def self.uninstall
      Base.stop(SERVICE_NAME_TEMPLATE % service_name)
      Base.unload(PLIST % service_name)
      remove_plist
      # TODO: Removing ipfw rule, is there more ruby way?
      system("ipfw list | grep 127.0.0.1,11280 | awk '{ system(\"sudo ipfw delete \" $1) }'")
    end
  end
end
