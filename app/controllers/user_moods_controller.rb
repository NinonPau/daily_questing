class UserMoodsController < ApplicationController
  before_action :authenticate_user!

  def new
    @user_mood = UserMood.new
  end

  def create
    @user_mood = UserMood.new(strong_params)
    @user_mood.user = current_user
    if @user_mood.save
      redirect_to root_path
    else
      render :home, status: :unprocessable_entity
    end
  end

  def edit
    @user_mood = UserMood.find(params[:id])
  end

  def update
    @user_mood = UserMood.find(params[:id])
    @user_mood.update(strong_params)
    @user_mood.xp_bonus = set_xp_bonus
    @user_mood.save
    redirect_to root_path
  end

  private

  def set_xp_bonus
    case @user_mood.mood_type
    when "Amazing" then 1.25
    when "Good" then 1.5
    when "Ok'ish" then 2.0
    when "Bad" then 3.0
    end
  end

  def strong_params
    params.require(:user_mood).permit(:mood_type, :xp_bonus, :date)
  end

end
