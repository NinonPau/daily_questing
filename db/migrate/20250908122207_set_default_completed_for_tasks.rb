class SetDefaultCompletedForTasks < ActiveRecord::Migration[7.1]
  def change
    change_column_default :tasks, :completed, from: nil, to: false
  end
end
