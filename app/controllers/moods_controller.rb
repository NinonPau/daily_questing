class MoodsController < ApplicationController
  def index
    @moods = Moods.all
  end
end
