class OrganizationsController < ApplicationController
  def create
  end

  def destroy
  end

  def index
  end

  def show
  end

  def new
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end

  def edit
  end
end
