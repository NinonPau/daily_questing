class PagesController < ApplicationController
  def home
    if user_signed_in?
      @user = current_user
    end
  end
end
