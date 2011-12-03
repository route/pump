module Yippee
  class MasqDNS
    class Names
      def initialize(names)
        @names = names.map { |name| Resolv::DNS::Name.create(name) }
      end

      def include?(name)
        !@names.select { |n| name.eql?(n) || name.subdomain_of?(n) }.empty?
      end
    end
  end
end