module ChatsHelper
	
	def organization_users
		@current_user.organization.users    
	end
	
end
