class UserMoodsController < ApplicationController
  before_action :authenticate_user!
  def index
    # @moods = UserMood.all
    @user_mood = current_user.user_mood || UserMood.new(user: current_user)
  end


  def create
    @user_mood = UserMood.new(user_mood_params)
    @user_mood.user = current_user
      if @user_mood.save
        redirect_to user_moods_path, notice: "Mood selected successfully!"
      else
        render :index, status: :unprocessable_entity
      end
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
