module UsersHelper

	def is_admin?
		self.admin
	end
	
	def has_organization?
		@current_user.organization.present?
	end

end
