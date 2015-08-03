require 'rails_helper'

RSpec.describe User, type: :model do
  describe "should have auth_token" do
  	let(:token) { SecureRandom.urlsafe_base64 }
  	let(:user_factory) { FactoryGirl.create(:user) }
  	let(:user) {user = User.new(name: "user", email: "qw@qw.ru", email_confirmation: "qw@qw.ru", password: "qwertyui", 
  		password_confirmation: "qwertyui")}
    let(:user_with_org) { FactoryGirl.create(:user_with_org)}


  	it "respond_to" do
     is_expected.to respond_to(:invite_key)
  	 is_expected.to respond_to(:auth_token)
     is_expected.to respond_to(:invited)
     is_expected.to respond_to(:privilages)
  	end

    it "when #invited?" do
      expect(user_factory.invited?).to eq false
    end

    it "when #create_invite_key" do
      expect{User.create_invite_key(user_with_org)}.to change{user_with_org.invite_key}.from(nil)
    end

  	it "when user save auth_token should not be blank" do
  		expect{ user.save }.to change{user.auth_token}.from(nil)
  	end

  end

end
