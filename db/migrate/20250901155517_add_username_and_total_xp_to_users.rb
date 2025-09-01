class AddUsernameAndTotalXpToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :username, :string
    add_column :users, :total_xp, :float
  end
end
