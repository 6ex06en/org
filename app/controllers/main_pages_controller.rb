class MainPagesController < ApplicationController
  def start
  	@user = User.new
  	@organization = Organization.new
  end
end
