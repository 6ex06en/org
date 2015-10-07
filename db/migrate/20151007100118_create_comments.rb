class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :task, index: true
      t.string :commenter
      t.string :comment

      t.timestamps null: false
    end
    add_foreign_key :comments, :tasks
  end
end
