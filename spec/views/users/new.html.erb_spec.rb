require 'rails_helper'

RSpec.describe "users/new.html.erb", type: :view do
  subject { page }
  before { visit "users/new"  }

  it "have link to root_path" do
  	is_expected.to have_link("SignIn", href: root_path)
  end

  it "when click 'SignIn' link" do
  	click_link "SignIn"
  	is_expected.to have_content("History")
  end

end
