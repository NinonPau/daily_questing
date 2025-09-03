class PagesController < ApplicationController
  before_action :set_page, only: [:show, :edit, :update]
  def index
    @pages = policy_scope(Page) 
  end

  def show
    authorize @page
  end

  def edit
    authorize @page
  end

  def update
    authorize @page
    if @page.update(page_params)
      redirect_to @page, notice: "Page mise à jour."
    else
      render :edit
    end
  end

  def home
    if user_signed_in?
      @user = current_user
    end
  end

  private

  def set_page 
    @page = Page.find(params[:id])
  end

  def page_params 
    params.require(:page).permit(:title, :content)
  end
end
