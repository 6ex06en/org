class AddTypeToChats < ActiveRecord::Migration
  def change
    add_column :chats, :type, :string
  end
end
