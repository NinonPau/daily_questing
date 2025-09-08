class AddPartnerIdToTasks < ActiveRecord::Migration[7.1]
  def change
    add_column :tasks, :partner_id, :bigint
    add_foreign_key :tasks, :users, column: :partner_id
  end
end
