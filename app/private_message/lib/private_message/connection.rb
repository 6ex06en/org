module PrivateMessage
  class Connection

    attr_reader :channels, :connection, :user

    def initialize(ws, valid_user)
        @channels = []
        @connection = ws
        @user = valid_user
        cached_channels
    end

    def cached_channels
      @user.chats.each do |c|
        @channels << c.name
      end
    end

    def has_channel?(channel_name)
      # p "current_user has_channel #{channel_name}? - #{channels.include? channel_name}"
      channels.include? channel_name
    end

  end
end
