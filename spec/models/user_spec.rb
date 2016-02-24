require 'rails_helper'

RSpec.describe User, type: :model do

  include Validator
  
  describe "User" do
  	let(:token) { SecureRandom.urlsafe_base64 }
  	let(:user) { FactoryGirl.create(:user) }
    let(:user_with_org) { FactoryGirl.create(:user_with_org) }
    let(:user_with_org2) { FactoryGirl.create(:user_with_org) }
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
     is_expected.to respond_to(:chats)
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

    end

    describe "channels specs" do

      let(:allowed_channel) {FactoryGirl.create(:chat)}
      let(:disallowed_channel) {FactoryGirl.create(:chat)}

      before(:each) do
        UsersChat.create(chat_id: allowed_channel.id, user_id: other_user.id)
      end

      xit "when create new chat via UsersChat model" do
        user_with_org.new_chat("test_chat")
        expect(user_with_org.chats.first.name).to eq "test_chat"
      end

      describe "join or leave chat" do

        it "when join the chat and chat allowed" do
          user_with_org.join_chat(allowed_channel.id)
          expect(user_with_org.chats).to include allowed_channel
        end

        xit "when join the chat and chat not allowed" do
          user_with_org.join_chat(disallowed_channel.id)
          expect(user_with_org.chats).to_not include disallowed_channel
          expect(user_with_org.join_chat(disallowed_channel.id)).to raise_exception
        end

        xit "when #leave_chat" do
          expect{user_with_org.leave_chat(allowed_channel.id)}
            .to change{user_with_org.chats.count}.from(1).to(0)
        end

        descibe "module Validator" do

          let(:chat_another_user) {FactoryGirl.create(:chat)}

          before(:each) do
            user_with_org2.join_chat(chat_another_user.id)
          end

          describe "#same_organization?" do

            xit "when chat from other organization - fail" do
              expect(user_with_org.join_to(chat_another_user.id)).to be_nil
              user_with_org.join_to(chat_another_user.id)
              expect(error).to eq "User from other organization"
            end

            xit "when users from one organization - success" do
              expect(user_with_org.join_to(chat_another_user.id)).to be_truthy
            end

          end

          xit "#valid?" do
          end

        end

      end

    end

  end

end
