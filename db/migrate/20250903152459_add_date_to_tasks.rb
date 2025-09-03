class AddDateToTasks < ActiveRecord::Migration[7.1]
  def change
    add_column :tasks, :date, :date
  end
end
