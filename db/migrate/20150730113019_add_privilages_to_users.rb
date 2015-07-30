class AddPrivilagesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :privilages, :string
    add_column :users, :invited, :boolean, default: false
  end
end
