require_relative "connection"

module PrivateMessage
  class Clients
    
    @connected = []

    def self.connected
      @connected
    end

    def self.add(ws)
      @connected.push(Connection.new(ws))
    end
  end
end
