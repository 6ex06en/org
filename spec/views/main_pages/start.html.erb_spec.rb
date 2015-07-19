require 'rails_helper'

RSpec.describe "start page", type: :view do
	subject { page }
	before { visit root_path }

  it "should have sign up link" do
  	is_expected.to have_link("SignUp", href: new_user_path)
  end

  it "when click signup link" do
  	click_link "SignUp"
  	is_expected.to have_content("Create new user")
  end
end
