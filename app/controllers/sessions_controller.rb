class SessionsController < ApplicationController
  before_action :signed_in_user, only: [:destroy]
  before_action :already_signed, only: [:create]

  def create
    
  	user = User.find_by_email(params[:session][:email])
  	if user && user.authenticate(params[:session][:password])
  		flash[:success] = "Welcome #{user.name}"
  		sign_in(user)
  		redirect_to root_path
  	else
  		flash.now[:danger] = "Invalid email or password"
  		render "main_pages/start"
  	end
  end

  def index
    render "main_pages/start"
  end

  def destroy
      sign_out
      redirect_to root_path
  end

  private

  def session_params
  	params.require(:session).permit(:password, :email)
  end

end
