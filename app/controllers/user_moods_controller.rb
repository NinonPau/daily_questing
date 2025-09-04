class UserMoodsController < ApplicationController
  before_action :authenticate_user!

  def index
    @user_mood = UserMood.new
  end

  # change create method and attach it to first button press
  
  def create
    @user_mood = UserMood.find(params[:id])
  end

  def update
    @user_mood = UserMood.find(params[:id])
    @user_mood.update(strong_params)
    @user_mood.save
    redirect_to root_path
  end

  private

  # def xp_bonus
  #   case mood.name
  #   when "Amazing" then 0.25
  #   when ""
  #   end
  # end

  def strong_params
    params.require(:user_mood).permit(:mood_type, :id)
  end

end
