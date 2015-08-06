require 'rails_helper'

RSpec.describe User, type: :model do
  describe "User" do
  	let(:token) { SecureRandom.urlsafe_base64 }
  	let(:user) { FactoryGirl.create(:user) }
  	let(:other_user) {user = User.new(name: "user", email: "qw@qw.ru", email_confirmation: "qw@qw.ru", password: "qwertyui", 
  		password_confirmation: "qwertyui")}
    let(:admin) { FactoryGirl.create(:admin)}


  	it "respond_to" do
     is_expected.to respond_to(:join_to)
  	 is_expected.to respond_to(:auth_token)
     is_expected.to respond_to(:invited)
     is_expected.to respond_to(:privilages)
     is_expected.to respond_to(:tasks)
     is_expected.to respond_to(:assigned_tasks)
  	end

    it "when #invited?" do
      expect(user.invited?).to be_falsey
    end

    it "when #create_invitation" do
      expect{User.create_invitation(user, admin)}.to change{user.join_to}.from(nil)
      expect(user.join_to).to eq(admin.organization.id)
    end

  	it "when user save auth_token should not be blank" do
  		expect{ other_user.save }.to change{other_user.auth_token}.from(nil)
  	end

    describe "#assign_task" do

      it "creates task" do
        expect{admin.assign_task(user, "test")}.to change(Task, :count).by(1)
      end

      it "admin should have #assigned_tasks" do
        admin.assign_task(user, "test")
        expect(admin.assigned_tasks).to include(user)
      end

      it "user should have #tasks" do
        admin.assign_task(user, "test")
        expect(user.tasks).to include(admin)
      end

    end

  end

end
