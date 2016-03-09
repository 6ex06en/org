# require_relative "../../../helpers/sessions_helper.rb"

module PrivateMessage
  class Connection

    # include SessionsHelper

    attr_reader :channels, :connection, :user

    def initialize(ws, valid_user)
      begin
        @channels = []
        @connection = ws
        @user = valid_user
        cache_channels
      rescue => e
        raise e
      end
    end

    def cache_channels
      @user.chats.each do |c|
        @channels << c.name
      end
    end
    
    def has_channel?(channel_name)
      channels.include? channel_name
    end

  end
end
