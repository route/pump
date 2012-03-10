module Pump
  module Install
    module Firewall
      def self.install
        %x(ipfw add 50 fwd 127.0.0.1,11280 tcp from any to me dst-port 80 in)
      end

      def self.uninstall
        %x(ipfw delete 50)
      end
    end
  end
end
