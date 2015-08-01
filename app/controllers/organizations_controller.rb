class OrganizationsController < ApplicationController
  before_action :signed_in_user, only: [:destroy, :create]

  def create
    user = current_user
    unless user.organization_id.nil?
      flash.now[:danger] = "Вы уже состоите в организации"
      render "main_pages/start"
    else 
      @organization = user.build_organization(organization_params)
      if @organization.valid? && user.save && @organization.save
        user.assign_attributes(admin: true, invited: true)
        user.save(validate: false)
        flash[:success] = "Организация создана"
        redirect_to root_path
      else
        render "main_pages/start"
      end
    end
  end

  def destroy
    user = current_user
    user.assign_attributes(organization_id: nil, admin:false, invited:false)
    user.save(validate: false)
    redirect_to root_path
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
