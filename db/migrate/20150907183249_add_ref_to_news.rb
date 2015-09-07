class AddRefToNews < ActiveRecord::Migration
  def change
    add_reference :news, :object, polymorphic:true, index: true
    add_column :news, :reason, :string
    add_foreign_key :news, :objects
  end
end
