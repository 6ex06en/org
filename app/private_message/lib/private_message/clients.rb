require_relative "connection"

module PrivateMessage
  class Clients

    def self.connected
      @connected ||= []
    end

    def self.add(ws, valid_user)
      connected.push(Connection.new(ws, valid_user))
      # если нужно максимум только одно соединение у одного пользователя
      # connected.push(Connection.new(ws, valid_user)) unless connected? valid_user
    end

    def self.connected?(user)
      connected.find do |c|
        c.user.name == user.name
      end
    end

  end
end
