class FixFrozenName < ActiveRecord::Migration[7.1]
  def change
    rename_column :user_tasks, :frozen, :ignored
  end
end
