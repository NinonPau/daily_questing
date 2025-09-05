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
    params.require(:user_mood).permit(:mood_type, :xp_bonus, :date)
  end

end
