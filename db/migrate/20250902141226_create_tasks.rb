class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.text :description
      t.boolean :daily
      t.boolean :completed
      t.float :xp
      t.boolean :duo

      t.timestamps
    end
  end
end
