class AddDefaultToUsermood < ActiveRecord::Migration[7.1]
  def change
    change_column_default :user_moods, :mood_type, 'Not selected'
  end
end
