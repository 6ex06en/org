class CreateNews < ActiveRecord::Migration
  def change
    create_table :news do |t|
      t.string :body
      t.boolean :readed, default: false, index:true
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :news, :users
  end
end
