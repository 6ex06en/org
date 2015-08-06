class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.datetime :date_exec, index:true
      t.references :manager, index: true
      t.references :executor, index: true
      t.string :description

      t.timestamps null: false
    end
    add_foreign_key :tasks, :managers
    add_foreign_key :tasks, :executors
  end
end
