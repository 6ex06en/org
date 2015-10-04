class OrganizationsController < ApplicationController
  before_action :signed_in_user, only: [:destroy, :create, :invite_user, :join_to_organization]
  before_action :admin?, only: [:invite_user]
  after_action  ->(user = @current_user) {user.clean_tasks}, only: [:destroy]

  def create
    @current_user = current_user
    unless @current_user.organization_id.nil?
      flash.now[:danger] = "Вы уже состоите в организации"
      render "main_pages/start"
    else 
      @organization = @current_user.build_organization(organization_params)
      if @organization.valid? && @current_user.save && @organization.save
        @current_user.assign_attributes(admin: true, invited: true)
        @current_user.save(validate: false)
        flash[:success] = "Организация создана"
        redirect_to root_path
      else
        @object_with_errors = @organization
        render "main_pages/start"
      end
    end
  end

  def destroy
    user = current_user
    News.create_news(user, :leave_organization)
    user.assign_attributes(organization_id: nil, admin:false, invited:false)
    user.save(validate: false)
    redirect_to root_path
  end

  def index
  end

  def show
  end

  def invite_user
    user = User.find_by_email(params[:invite_user][:email])
    if user
      User.create_invitation(user, current_user)        
      Main.delay.join_to_organization(user, current_user)
      flash[:success] = "Приглашение отправлено"
      redirect_to edit_user_path(current_user)
    else
      flash[:danger] = "Пользователь с таким e-mail не найден"
      redirect_to edit_user_path(current_user)
    end
  end

  def join_to_organization
    if current_user.admin?
      flash[:danger] = "Сначала покиньте текущую организацию"
      redirect_to edit_user_path(@current_user)
    else
      organization = Organization.find(params[:id])
      current_user.update_attributes(join_to: nil, invited: true, organization_id: organization.id)
      News.create_news(current_user, :new_user)
      flash[:success] = "Добро пожаловать в #{organization.name}!"
      redirect_to edit_user_path(@current_user)
    end
  end

  def new
    respond_to do |format|
      format.html {}
      format.js
    end
  end

  def edit
  end

  private

  def organization_params
    params.require(:organization).permit(:name)
  end

  def admin?
    unless current_user.admin
      redirect_to root_path, notice: "Вы не администратор"
    end
  end
  
end
