class CreateUserTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :user_tasks do |t|
      t.references :user, null: false, foreign_key: true
      t.references :task, null: false, foreign_key: true
      t.boolean :completed
      t.boolean :frozen
      t.float :xp_earned

      t.timestamps
    end
  end
end
