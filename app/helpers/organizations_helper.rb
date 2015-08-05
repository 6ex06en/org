module OrganizationsHelper

  def one_admin?(organization)
  	if current_user.admin
    	User.where(organization_id: organization, admin: true).count == 1
    else 
    	false
    end 
  end

end
