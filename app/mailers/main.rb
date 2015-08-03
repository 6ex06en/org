class Main < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.main.join_to_organization.subject
  #
  def join_to_organization(user, inviter)
    @greeting = "Здравствуйте"
    @inviter = inviter
    @user = user
    mail(to: @user.email, subject: "Organizer.Приглашение")
  end
end
