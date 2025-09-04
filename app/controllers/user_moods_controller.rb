class UserMoodsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @user_mood = current_user.user_mood
  end

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
