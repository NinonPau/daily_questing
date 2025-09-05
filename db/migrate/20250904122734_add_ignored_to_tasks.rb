class AddIgnoredToTasks < ActiveRecord::Migration[7.1]
  def change
    add_column :tasks, :ignored, :boolean
  end
end
