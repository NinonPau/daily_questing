class RemovePartnerIdAndDuoFromTasks < ActiveRecord::Migration[7.1]
  def change
    remove_column :tasks, :partner_id, :bigint
    remove_column :tasks, :duo, :boolean
  end
end
