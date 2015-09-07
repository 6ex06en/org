class RemoveBodyFromNews < ActiveRecord::Migration
  def change
    remove_column :news, :body, :string
    remove_column :news, :user_id, :integer
  end
end
