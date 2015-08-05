class RemoveInviteKeyFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :invite_key, :string
    add_index :users, :join_to
  end
end
