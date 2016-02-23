require_relative "../../../helpers/sessions_helper.rb"

module PrivateMessage
  class Connection

    include SessionsHelper

    attr_reader :channels, :connection, :user

    def initialize(ws, valid_user)
      begin
        #p current_user
        @channels = []
        @connection = ws
        @user = valid_user
      rescue => e
        raise e
      end
    end

    def test
      p methods
    end

  end
end
