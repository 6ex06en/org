class ChatsController < ApplicationController

  before_action :signed_in_user

  respond_to :html, :js

  def index
    @chats = current_user.chats
    respond_with @chats
  end

end
