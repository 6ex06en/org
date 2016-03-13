require 'rails_helper'

RSpec.describe Chat, type: :model do

    let(:user1) { FactoryGirl.create(:user_with_org) }
    let(:user2) { FactoryGirl.create(:user_with_org,
                                    organization_id: user1.organization_id) }

    describe "#format_chat_name" do

      it "when chat_type = 'chat'" do
        user2.own_chats.create(name: "test", chat_type: "chat")
        expect(user2.chats.last.name).to eq "test_#{user2.id}"
      end

      describe "when chat_type = 'private'" do

        it "and creator's id of chat more then other user id" do
          user2.own_chats.create(name: user1.id, chat_type: "private")
          expect(user2.own_chats.last.name).to eq "#{user1.id}_#{user2.id}"
        end

        it "and creator's id of chat less then other user id" do
          user1.own_chats.create(name: user2.id, chat_type: "private")
          expect(user1.own_chats.last.name).to eq "#{user1.id}_#{user2.id}"
        end

      end

    end

    describe "validation #has_user?" do
      it "when chat_type == 'private'" do
        chat = user1.own_chats.create(name: 10000000, chat_type: "private")
        expect(chat).not_to be_valid
        expect(chat.errors.full_messages).to include "User not found"
      end
      it "when chat_type == 'chat'" do
        chat = user1.own_chats.create(name: 10000000, chat_type: "chat")
        expect(chat).to be_valid
        expect(chat.errors.full_messages).to_not include "User not found"
      end
    end

    describe "#invite_addressee" do

      it "when chat type == private" do
        expect{user1.own_chats.create(name: user2.id, chat_type: "private")}
          .to change{user2.chats.count}.by(1)
        chat = user1.own_chats.create(name: user2.id, chat_type: "private")
        expect(user2.chats.last.user).to eq user1
        expect(user2.chats.last).to eq chat
      end

      it "when chat type == chat" do
        expect{user1.own_chats.create(name: user2.id, chat_type: "chat")}
          .not_to change{user2.chats.count}.from(0)
      end

    end

end
