class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def edit
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

  private

  def user_params
    params.require(:user).permit(:email, :email_confirmation, :password, :password_confirmation, :name)
  end

end
