require 'socket'

module Pump
  class MasqDNS
    @@domain_names = Settings.domain_names
    @@resource = Resolv::DNS::Resource::IN::A.new("127.0.0.1")
    @@ttl = 10800 # 3 hours

    def initialize(addr, port)
      trap("HUP") { reload_domain_names }

      # Bind port to receive requests
      socket = UDPSocket.new
      socket.bind(addr, port)

      loop do
        # Receive and parse query
        data, sender_addrinfo = socket.recvfrom(512)
        Pump.logger.debug "Incoming request"

        Thread.new(data, sender_addrinfo) do |data, sender_addrinfo|
          sender_port, sender_ip = sender_addrinfo[1], sender_addrinfo[2]
          query = Resolv::DNS::Message.decode(data)
          Pump.logger.debug "Query: #{query.inspect}"
          answer = setup_answer(query)
          socket.send(answer.encode, 0, sender_ip, sender_port) # Send the response
          Pump.logger.debug "Answer: #{answer.inspect}"
        end
      end
    end

    # Setup answer
    def setup_answer(query)
      # Standard fields
      answer = Resolv::DNS::Message.new(query.id)
      answer.qr = 1                 # 0 = Query, 1 = Response
      answer.opcode = query.opcode  # Type of Query; copy from query
      answer.aa = 1                 # Is this an authoritative response: 0 = No, 1 = Yes
      answer.rd = query.rd          # Is Recursion Desired, copied from query
      answer.ra = 0                 # Does name server support recursion: 0 = No, 1 = Yes
      answer.rcode = 0              # Response code: 0 = No errors
      each_question(query, answer)  # There may be multiple questions per query
    end

    def each_question(query, answer)
      query.each_question do |name, typeclass|
        next unless typeclass.name.split("::").last == "A"    # We need only A-record
        if @@domain_names.include?(name)
          answer.add_answer(name, @@ttl, @@resource)          # Setup answer to this name
          answer.encode                                       # Don't forget encode it
        end
      end
      answer
    end

    def reload_domain_names
      @@domain_names = Settings.domain_names
    end
  end
end
