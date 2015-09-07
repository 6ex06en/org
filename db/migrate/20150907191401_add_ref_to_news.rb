class AddRefToNews < ActiveRecord::Migration
  def change
    add_reference :news, :user, index: true
    add_foreign_key :news, :users
  end
end
