class MoodsController < ApplicationController

  def index
    @moods = UserMood.all
  end

  #patch method to update the user_mood based on the mood_type


end
