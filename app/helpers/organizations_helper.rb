module OrganizationsHelper

  def one_admin?(organization)
    User.where(organization_id: organization, admin: true).count == 1
  end

end
