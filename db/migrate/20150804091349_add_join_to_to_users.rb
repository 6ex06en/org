class AddJoinToToUsers < ActiveRecord::Migration
  def change
    add_column :users, :join_to, :integer
  end
end
