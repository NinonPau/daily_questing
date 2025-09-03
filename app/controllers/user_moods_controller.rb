class UserMoodsController < ApplicationController

  def index
    # @moods = UserMood.all
    @user_mood = current_user.user_mood
  end



  #patch method to update the user_mood based on the mood_type

  def update
    @user_mood = UserMood.find(params[:id])
    @user_mood.update(strong_params)
    @user_mood.save
    redirect_to root_path
  end


  private

  def strong_params
    params.require(:user_mood).permit(:mood_type, :id)
  end

end
