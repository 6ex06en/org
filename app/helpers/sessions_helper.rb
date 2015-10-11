module SessionsHelper
	def sign_in(user)
		token = User.new_token
		cookies.permanent[:token] = token
		user.update_attribute(:auth_token, User.encrypt(token))
		self.current_user = user
	end

	def sign_out
		token = User.new_token
		current_user.update_attribute(:auth_token, User.encrypt(token))
		cookies.delete(:token)
		self.current_user= nil
	end

	def current_user=(user)
		@current_user = user
	end

	def current_user
		auth_token = User.encrypt(cookies[:token])
		@current_user ||= User.find_by_auth_token(auth_token.to_s)
	end

	def signed_in?
		!current_user.nil?
	end

  def store_location
   	session[:return_to] = request.url if request.get?
  end

	def signed_in_user
    unless signed_in?
      store_location
      redirect_to root_url, notice: "Please sign in."
    end
	end

	def current_user?(user)
    current_user == user
	end

	def redirect_back_or(default)
  	redirect_to(session[:return_to] || default)
  	session.delete(:return_to)
  end

  def correct_user(id)
  	user = User.find_by_id(id)
  	redirect_to root_path unless current_user?(user)
	end

	def already_signed
		if @current_user   		
 			redirect_to request.url
 		end
	end
  
end
