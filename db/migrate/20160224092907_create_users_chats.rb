class CreateUsersChats < ActiveRecord::Migration
  def change
    create_table :users_chats, id:false do |t|
      t.references :chat, index: true
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :users_chats, :chats
    add_foreign_key :users_chats, :users
  end
end
