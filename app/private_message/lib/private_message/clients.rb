require_relative "connection"

module PrivateMessage
  class Clients

    # @connected = []

    def self.connected
      @connected ||= []
    end

    def self.add(ws, valid_user)
      p "start add Client method"
      connected.push(Connection.new(ws, valid_user)) unless connected? valid_user
      p "end add Client method"
    end
    
    def self.connected?(user)
      connected.find do |c| 
        c.user.name == user.name
      end
    end
    
  end
end

# PrivateMessage::Clients.add(:dfdf)
# PrivateMessage::Clients.add(:dfdff)
# PrivateMessage::Clients.add("434")
# p PrivateMessage::Clients.connected
