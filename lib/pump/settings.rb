require 'pathname'
require 'pump/masqdns/names'

module Pump
  module Settings
    PATTERN = File.join(USER_CONFIG_DIR, "*")

    def self.settings
      symlinks.map do |symlink|
        name = MasqDNS::Name.create File.basename(symlink)
        path = Pathname.new(symlink).realpath
        [name, path]
      end.compact
    end

    def self.symlinks
      Dir.glob(PATTERN).select do |file|
        File.lstat(file).symlink? && Pathname.new(file).exist?
      end
    end

    def self.domain_names
      MasqDNS::Names.new settings.map(&:first)
    end

    def self.first_level_domains
      names = domain_names.map { |domain| domain.to_a.last.to_s }
      names << "pump"
      names.uniq
    end

    def self.find_by_domain(name)
      settings.find { |domain, path| domain.to_s == name }
    end
  end
end
