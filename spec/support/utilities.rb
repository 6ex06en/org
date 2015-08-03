include ApplicationHelper

def sign_in(user, options={})
  if options[:no_capybara]
    # Sign in when not using Capybara.
    auth_token = User.new_token
    cookies[:token] = auth_token
    user.update_attribute(:auth_token, User.encrypt(auth_token))
  else
    visit root_path
    fill_in "E-mail", with: user.email
    fill_in "Password", with: user.password
    click_button "Submit"
  end
end