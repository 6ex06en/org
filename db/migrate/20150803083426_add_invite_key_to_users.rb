class AddInviteKeyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :invite_key, :string
  end
end
