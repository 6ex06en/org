require 'rails_helper'

RSpec.describe User, type: :model do

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

      let!(:allowed_channel) {FactoryGirl.create(:chat, chat_type: "private", user_id: user_with_org.id)}
      let!(:disallowed_channel) {FactoryGirl.create(:chat, chat_type: "private", user_id: user_with_org2.id)}

      # before(:each) do
      #   UsersChat.create(chat_id: allowed_channel.id, user_id: other_user.id)
      # end

      it "when create new chat via UsersChat model" do
        user_with_org.own_chats.create(name: "test_chat", chat_type: "private")
        expect(user_with_org.chats.last.name).to eq "test_chat"
        expect(Chat.last.user).to eql user_with_org
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

        describe "#invite_to_chat" do

          it "when success" do
            expect{user_with_org.invite_to_chat(user_with_org2, allowed_channel)}
              .to change{user_with_org2.chats.count}.by(1)
            user_with_org.invite_to_chat(user_with_org2, allowed_channel)
            expect(user_with_org2.chats).to include allowed_channel
          end

          it "when invited not exist or invited is not User" do
            expect(user_with_org.invite_to_chat(nil, allowed_channel)).to be_nil
          end

          xit "when inviter not owner the chat" do
          end
        end

        it "when #leave_chat" do
          expect{user_with_org.leave_chat(allowed_channel.id)}.to change{user_with_org.chats.count}.from(1).to(0)
        end

        describe "module Validator" do

          let(:chat_another_user) {FactoryGirl.create(:chat, chat_type: "chat", user_id: user_with_org2.id)}

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
