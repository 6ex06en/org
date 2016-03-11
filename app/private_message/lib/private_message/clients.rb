require_relative "connection"

module PrivateMessage
  class Clients

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
