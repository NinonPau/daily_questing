class UserMood < ApplicationRecord
  belongs_to :user
  after_create :set_default_mood

  def set_default_mood
    create_user_mood(mood_type: "Neutral") unless user_mood
  end

end
