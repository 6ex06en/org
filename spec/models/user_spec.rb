require 'rails_helper'

RSpec.describe User, type: :model do
  describe "should have auth_token" do
  	let(:token) { SecureRandom.urlsafe_base64 }
  	let(:user_factory) { FactoryGirl.create(:user) }
  	user = User.new(name: "user", email: "qw@qw.ru", email_confirmation: "qw@qw.ru", password: "qwertyui", 
  		password_confirmation: "qwertyui")

  	it "#auth_token" do
  	 is_expected.to respond_to(:auth_token)
  	end

  	it "when user save auth_token should not be blank" do
  		expect{ user.save }.to change{user.auth_token}.from(nil)
  	end
  end

end
