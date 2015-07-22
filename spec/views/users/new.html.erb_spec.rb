require 'rails_helper'

RSpec.describe "users/new.html.erb", type: :view do
  subject { page }
  before { visit "/users/new"  }

  it "have link to root_path" do
  	is_expected.to have_link("SignIn", href: root_path)
  end

  it "when click 'SignIn' link" do
  	click_link "SignIn"
  	is_expected.to have_content("History")
  end

  it "error messages after create invalid user" do
  	click_button "Submit"
  	is_expected.to have_content("Name is too short")
  end

  describe "when create user" do
  	before do
	  	fill_in "name", with: "user"
	  	fill_in "password", with: "password"
	  	fill_in "Confirmation password", with: "password"
	  	fill_in "email", with: "ex@ample.com"
	  	fill_in "Confirmation e-mail", with: "ex@ample.com"
	  	click_button "Submit"
  	end

  	it "redirect to root_path" do
  		expect(page).to have_content("History")
  	end

  	it "flash[:success]" do
  		expect(page).to have_css(".alert-success", text: "User created")
  	end

  	it "change User's count" do
  		expect(User.count).to eq(1)
  	end
  end

end
