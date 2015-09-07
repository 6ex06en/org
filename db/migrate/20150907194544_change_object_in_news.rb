class ChangeObjectInNews < ActiveRecord::Migration
  def change
  	rename_column :news, :object_id, :target_id
  	rename_column :news, :object_type, :target_type
  end
end
