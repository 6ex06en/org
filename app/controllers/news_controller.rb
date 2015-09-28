class NewsController < ApplicationController
  def index
    @news = current_user.news
    respond_to do |format|
      format.js {}
    end
  end

  def show
  end

  def destroy
  end
end
