class MainPagesController < ApplicationController
  def start
  	@user = User.new
  	@current_user = current_user
  	@organization = Organization.new
    @news = @current_user.news.preload(:target).where(readed: false) if @current_user
  end
end
