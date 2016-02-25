class ChangeTypeOnChat < ActiveRecord::Migration
  def change
    rename_column :chats, :type, :chat_type
  end
end
