class ChatsController < ApplicationController

  before_action :signed_in_user

  def index
    @chats = current_user.chats
    
    respond_to do |format|
      format.js {}
    end
    
  end

end
