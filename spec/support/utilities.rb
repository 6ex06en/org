include ApplicationHelper

RSpec::Matchers.define :have_submit_button do |value|
  match do |page|
    Capybara.string(page.body).has_selector?(:css, 'input[type="submit"][value="#{value}"]')
  end
end

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

def sign_out(options={})
  if options[:no_capybara]
    cookies.delete(:token)
  else
    visit root_path
    find(".dropdown_login").click
    click_link "Log out"
  end
end

def view_daytime_tasks(user)
  sign_in user
  find(".dropdown-togle-month").click
  within ".dropmenu-month" do
    find(".list-month:nth-child(8)").click
  end
  find(".dropdown-togle-year").click
  all(".list-year")[1].click
  within "#container_calendar" do 
      find(".calendar_day_wrapper:nth-child(10)").click
  end
  find("#tasks_of_day").click
end
