module SessionsHelper
	def sign_in(user)
		token = User.new_token
		cookies.permanent[:token] = token
		user.update_attribute(:auth_token, User.encrypt(token))
		self.current_user = user
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
end
