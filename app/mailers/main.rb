class Main < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.main.join_to_organization.subject
  #
  def join_to_organization
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
