class MainPagesController < ApplicationController
  def start
  	@user = User.new
  	@current_user = current_user
  	@organization = Organization.new
  end
end
