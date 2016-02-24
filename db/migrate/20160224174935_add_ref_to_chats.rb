class AddRefToChats < ActiveRecord::Migration
  def change
    add_reference :chats, :user, index: true
    add_foreign_key :chats, :users
  end
end
