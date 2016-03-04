module UsersHelper

	def is_admin?
		self.admin
	end
	
	def has_organization?
		current_user.organization.present?
	end
	
	def no_alone?
		users = current_user.organization.users
		users.many?
	end

end
