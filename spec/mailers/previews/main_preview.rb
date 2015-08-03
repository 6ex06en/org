# Preview all emails at http://localhost:3000/rails/mailers/main
class MainPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/main/join_to_organization
  def join_to_organization
    Main.join_to_organization(User.second, User.first)
  end

end
