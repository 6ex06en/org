module ChatsHelper

	def organization_users *arg
		if arg.one? && arg.first == :without_me
			current_user.organization.users.where.not(id: current_user.id )
		else
			current_user.organization.users
		end
	end

end
