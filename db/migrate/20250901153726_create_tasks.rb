class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.boolean :daily
      t.boolean :duo
      t.float :xp

      t.timestamps
    end
  end
end
