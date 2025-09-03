class UserMoodsController < ApplicationController

  def index
    # @moods = UserMood.all
    @user_mood = current_user.user_mood
  end



  #patch method to update the user_mood based on the mood_type

  def update
    raise
    @user_mood = UserMood(:id)
  end


  private

  #strong params

end
