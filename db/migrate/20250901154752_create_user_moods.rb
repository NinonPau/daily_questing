class CreateUserMoods < ActiveRecord::Migration[7.1]
  def change
    create_table :user_moods do |t|
      t.references :user, null: false, foreign_key: true
      t.string :mood_type
      t.float :xp_bonus
      t.date :date

      t.timestamps
    end
  end
end
