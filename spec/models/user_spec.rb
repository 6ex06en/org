require 'rails_helper'

RSpec.describe User, type: :model do
  describe "should have auth_token" do
  	let(:token) { SecureRandom.urlsafe_base64 }
  	let(:user) { FactoryGirl.create(:user) }
  	let(:user) {user = User.new(name: "user", email: "qw@qw.ru", email_confirmation: "qw@qw.ru", password: "qwertyui", 
  		password_confirmation: "qwertyui")}
    let(:user_with_org) { FactoryGirl.create(:user_with_org)}


  	it "respond_to" do
     is_expected.to respond_to(:join_to)
  	 is_expected.to respond_to(:auth_token)
     is_expected.to respond_to(:invited)
     is_expected.to respond_to(:privilages)
  	end

    it "when #invited?" do
      expect(user.invited?).to be_falsey
    end

    it "when #create_invitation" do
      expect{User.create_invitation(user, user_with_org)}.to change{user.join_to}.from(nil)
      expect(user.join_to).to eq(user_with_org.organization.id)
    end

  	it "when user save auth_token should not be blank" do
  		expect{ user.save }.to change{user.auth_token}.from(nil)
  	end



  end

end
