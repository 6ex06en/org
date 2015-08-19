class AddStatusToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :status, :string, default: :ready
    add_index :tasks, :status
  end
end
