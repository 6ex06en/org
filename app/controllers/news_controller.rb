class NewsController < ApplicationController
  before_action :signed_in_user
  def index
    @news = current_user.news.preload(:target).where(readed: false).order(created_at: :desc)
    respond_to do |format|
      format.js {}
    end
  end

  def show
  end

  def read_news
    news = current_user.news.find_by_id(params[:id])
    news.update_attributes(readed: true)
    respond_to do |format|
      format.js {render nothing: true}
    end
  end

end
