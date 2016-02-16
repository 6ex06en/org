module PrivateMessage
  class Clients

    def self.connected
      @connected = []
    end

    def self.add(ws)
      @connected.push(Connection.new(ws))
    end
  end
end
