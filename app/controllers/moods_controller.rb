class MoodsController < ApplicationController

  def index
    @moods = UserMood.all
  end

end
