class MainPagesController < ApplicationController
  def start
  	@user = User.new
  end
end
