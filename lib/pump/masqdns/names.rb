require 'resolv'

module Pump
  class MasqDNS
    class Name
      def self.create(name)
        Resolv::DNS::Name.create(has_domain?(name) ? "#{name}." : "#{name}.pump.")
      end

      def self.has_domain?(name)
        name.split(".").length >= 2
      end
    end

    class Names < ::Array
      def include?(name)
        !exclude?(name)
      end

      def exclude?(name)
        select { |n| name.eql?(n) || name.subdomain_of?(n) }.empty?
      end
    end
  end
end
