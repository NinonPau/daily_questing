class AddLeveltoUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :level, :integer
  end
end
