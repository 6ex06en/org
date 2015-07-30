class SessionsController < ApplicationController
  def new
  end

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

  def destroy
      sign_out
      redirect_to root_path
  end

  def update
  end

  private
  def session_params
  	params.require(:session).permit(:password, :email)
  end
end
