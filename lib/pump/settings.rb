require 'pathname'

module Pump
  USER_CONFIG_DIR = File.join(ENV["HOME"], ".pump")

  module Settings
    PATTERN = File.join(USER_CONFIG_DIR, "*")

    def self.settings
      symlinks.map do |symlink|
        name = File.basename(symlink)
        # TODO: Currently are using only .pump domain
        if MasqDNS::Name.create(name).subdomain_of?(Resolv::DNS::Name.create("pump."))
          [MasqDNS::Name.create(name), Pathname.new(symlink).realpath]
        end
      end.compact
    end

    def self.symlinks
      Dir.glob(PATTERN).select { |file| File.lstat(file).symlink? }
    end

    def self.domain_names
      MasqDNS::Names.new settings.map(&:first)
    end

    def self.first_level_domains
      domain_names.map { |domain| domain.to_a.last.to_s }.uniq
    end

    def self.find_by_domain(name)
      settings.find { |domain, path| domain.to_s == name }
    end
  end
end
