require 'socket'
require 'resolv'

module Yippee
  class MasqDNS
    def initialize(addr, port)
      hosts = [{ :name => "domain.yippee", :ip => "127.0.0.1" }]

      # Bind port to receive requests
      socket = UDPSocket.new
      socket.bind(addr, port)

      loop do
        # Receive and parse query
        data = socket.recvfrom(10000)
        query = Resolv::DNS::Message.decode(data[0])

        # Setup answer
        answer = Resolv::DNS::Message.new(query.id)
        answer.qr = 1                                           # 0 = Query, 1 = Response
        answer.opcode = query.opcode                            # Type of Query; copy from query
        answer.aa = 1                                           # Is this an authoritative response: 0 = No, 1 = Yes
        answer.rd = query.rd                                    # Is Recursion Desired, copied from query
        answer.ra = 0                                           # Does name server support recursion: 0 = No, 1 = Yes
        answer.rcode = 0                                        # Response code: 0 = No errors

        query.each_question do |question, typeclass|            # There may be multiple questions per query
          name = question.to_s                                  # The domain name looked for in the query.
          record_type = typeclass.name.split("::").last         # For example "A", "MX"
          next unless record_type == "A"
          ttl = 16000
          record = hosts.find { |host| host[:name] == name }
          unless record.nil?
            # Setup answer to this question
            answer.add_answer(name + ".", ttl, typeclass.new(record[:ip]))
            answer.encode
          end
        end

        # Send the response
        socket.send(answer.encode, 0, data[1][2], data[1][1])
      end
    end
  end
end
