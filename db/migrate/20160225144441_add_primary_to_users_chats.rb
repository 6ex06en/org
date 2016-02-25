class AddPrimaryToUsersChats < ActiveRecord::Migration
  def change
    add_column :users_chats, :id, :primary_key
  end
end
