require 'rails_helper'

RSpec.describe "users/edit.html.erb", type: :view do

  describe "when admin user" do
  	let(:admin) {FactoryGirl.create(:user, admin:true)}
  	before { sign_in user}
  end

  it "page should contain invite form" do
  end

end
