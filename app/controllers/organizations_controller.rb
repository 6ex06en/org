class OrganizationsController < ApplicationController
  def create
    @organization = current_user.build_organization(organization_params)
    if current_user.save && @organization.save
      flash[:success] = "Организация создана"
      redirect_to root_path
    else
      render "main_pages/start"
    end
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


  private

  def organization_params
    params.require(:organization).permit(:name)
  end
  
end
