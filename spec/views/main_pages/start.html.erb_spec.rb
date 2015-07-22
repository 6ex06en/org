require 'rails_helper'

RSpec.describe "start page,", type: :view do
	subject { page }
	before { visit root_path }

  it "should have sign up link" do
  	is_expected.to have_link("SignUp", href: new_user_path)
  end

  it "when click signup link" do
  	click_link "SignUp"
  	is_expected.to have_content("Create new user")
  end

  describe "when signin" do
  	let(:user) { FactoryGirl.create(:user) }
  	before do
	  	fill_in "E-mail", with: user.email
	  	fill_in "Password", with: user.password
	  	click_button "Submit"
  	end
  	it "not render signin form" do
  		expect(page).to_not have_css("#submit_signin")
  	end

  	it "should be flash notice" do
  		is_expected.to have_content("Welcome #{user.name}")
  	end

  end
end
