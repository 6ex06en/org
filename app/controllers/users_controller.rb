class UsersController < ApplicationController
  before_action :signed_in_user, only: [:edit, :show]
  before_action :correct_user, only: [:edit, :show]

  def new
    @user = User.new
  end

  def edit
    @user = current_user
    @organization = Organization.find_by_id(@user.join_to)
  end

  def show
  end

  def index
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "User created"
      redirect_to root_path
    else
      render "users/new"
    end
  end

  def destroy
  end

  def update
  end

  def destroy_invitation
    current_user.update_attributes(join_to: nil)
    respond_to do |format|
      format.html { redirect_to edit_user_path(@current_user)}
      format.js
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :email_confirmation, :password, :password_confirmation, :name)
  end

  def correct_user
    user = User.find_by_id(params[:id])
    redirect_to root_path unless current_user?(user)
  end

end
