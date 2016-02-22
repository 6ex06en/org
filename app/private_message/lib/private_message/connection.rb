# require "faye/websocket"

module PrivateMessage
  class Connection

    attr_reader :channels, :connection, :user

    def initialize(ws)
      @channels = []
      @connection = ws
      @user = current_user
    end

  end
end
