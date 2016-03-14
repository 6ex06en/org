require 'rails_helper'

# require_relative "../../app/private_message/lib/private_message"

# RSpec.configure do |c|
#   c.include Validator
# end

RSpec.describe User, type: :model do
  include User::Validator
  include PrivateMessage

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

      let!(:allowed_channel) {FactoryGirl.create(:chat, chat_type: "chat", user_id: user_with_org.id)}
      let!(:disallowed_channel) {FactoryGirl.create(:chat, chat_type: "chat", user_id: user_with_org2.id)}

      it "when create new chat via UsersChat model" do
        user_with_org.own_chats.create(name: "test_chat", chat_type: "chat")
        expect(user_with_org.chats.last.name).to eq "test_chat_#{user_with_org.id}"
        expect(Chat.last.user).to eql user_with_org
      end

      describe "join or leave chat" do

        it "when join the chat and chat allowed" do
          user_with_org.join_chat(allowed_channel.id)
          expect(user_with_org.chats).to include allowed_channel
        end

        describe "when #leave_chat" do

          it "count of chats must be decreased" do
            expect{user_with_org.leave_chat(allowed_channel.id)}.to change{user_with_org.chats.count}.from(1).to(0)
          end

          it "chat must be deleted if no users" do
            user_with_org.leave_chat(allowed_channel.id)
            expect(user_with_org.chats).not_to include allowed_channel
            expect(Chat.find_by(id: allowed_channel.id)).to be_nil
          end

        end

        describe "after joined to channel" do
          
          let(:ws_client) {PrivateMessage::Clients.add("fake_ws", user_with_org).last}
          before { user_with_org.update_attributes(organization_id: user_with_org2.organization_id) }
          

          it "increase count #cache_channels in PrivateMessage::Connection instance" do
            # ws_client = PrivateMessage::Clients.add("fake_ws", user_with_org).last
            expect(ws_client.channels).to contain_exactly allowed_channel.name
            user_with_org2.invite_to_chat(user_with_org, disallowed_channel)
            expect(ws_client.channels).to include disallowed_channel.name
          end

          it "decrease count #cache_channels in PrivateMessage::Connection instance" do
            p "------+++="
            p "#{ws_client.channels} - ws_client"
            p "#{user_with_org.chats.map &:name} - user_with_org"
            p "++++++++++++++"
            # ws_client = PrivateMessage::Clients.add("fake_ws", user_with_org).last
            #puts "user_with_org1 chats before inviting #{user_with_org.chats.count}"
            #p "user_with_org1 chats before inviting #{ws_client.channels}"
            user_with_org2.invite_to_chat(user_with_org, disallowed_channel)
            #puts "user_with_org1 chats after inviting #{user_with_org.chats.count}"
            #p "user_with_org1 chats after inviting #{ws_client.channels}"
            # p user_with_org.chats
            expect(ws_client.channels).to include disallowed_channel.name
            p "ws_client.name - #{ws_client.user.name}"
            p "ws_client.channels - #{ws_client.channels}"
            p "----------"
            user_with_org.leave_chat(disallowed_channel.id)
            expect(ws_client.channels).to_not include disallowed_channel.name
            #   .to change{ws_client.channels.count}.by(-1)
            # expect{user_with_org.leave_chat(disallowed_channel.id)}
            #   .to change{ws_client.channels.count}.by(-1)
            # p ws_client.channels
          end
        end

        describe "#invite_to_chat" do
          
          before { user_with_org.update_attributes(organization_id: user_with_org2.organization_id) }

          it "when success" do
            expect{user_with_org.invite_to_chat(user_with_org2, allowed_channel)}
              .to change{user_with_org2.chats.count}.by(1)
            user_with_org.invite_to_chat(user_with_org2, allowed_channel)
            expect(user_with_org2.chats).to include allowed_channel
          end


          it "when invited not exist or invited is not User" do
            expect(user_with_org.invite_to_chat(nil, allowed_channel)).to be_nil
          end

          it "when inviter not owner the chat" do
            expect{user_with_org2.invite_to_chat(user_with_org, allowed_channel)}.to raise_exception StandardError, "User not owner the chat"
          end
        end


        describe "module Validator" do

          let(:chat_another_user) {FactoryGirl.create(:chat, chat_type: "chat", user_id: user_with_org2.id)}

          describe "#same_organization?" do

            it "when chat from other organization - fail" do
              # expect(user_with_org.join_to(user_with_org2, chat_another_user.id)).to be_nil
              user_with_org.join_chat(chat_another_user.id)
              expect(user_with_org.error).to eq "User from other organization"
            end

            xit "when users from one organization - success" do
              expect(user_with_org.join_to(chat_another_user.id)).to be_truthy
            end

          end

          describe "#valid?" do
            describe "when all valid" do

              subject(:validation) {user_with_org2.valid_channel? owner_chat?: [chat_another_user]}

              it "method return true" do
                expect(validation).to be_truthy
              end

              it "method #error return nil" do
                expect{validation}.not_to change{user_with_org2.error}.from nil
              end

            end

            describe "when validation fail" do

              subject(:validation) {user_with_org.valid_channel? owner_chat?: [chat_another_user]}

              it "method return false" do
                expect(validation).to be_falsey
              end

              it "method #error return not nil" do
                expect{validation}.to change{user_with_org.error}.from nil
              end

            end

            it "when argument it is a not exists method" do
              expect{user_with_org.valid_channel?(:validation_method)}.to raise_error(NoMethodError)
            end
          end
        end

      end

    end

  end

end
