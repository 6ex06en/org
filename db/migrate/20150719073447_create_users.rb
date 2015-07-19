class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, index:true
      t.string :email, index:true
      t.string :admin, default: false 
      t.string :password
      t.string :auth_token

      t.timestamps null: false
    end
  end
end
