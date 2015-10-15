class AddReferencesToOption < ActiveRecord::Migration
  def change
    add_reference :options, :user, index: true
    add_foreign_key :options, :users
  end
end
