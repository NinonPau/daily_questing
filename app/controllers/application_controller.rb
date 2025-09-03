class ApplicationController < ActionController::Base
  include Pundit

  before_action :configure_permitted_parameters, if: :devise_controller?#step one to change automatique form of registration (+ username)


  protected #private ne peut etre appele que ds la meme instance/ protected depuis l'interieur de l'object(peut appeler avant before_action sans le rendre public)restreint mais appelable pour callback.

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end # ajoute username to the formulaire

  private

   def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end

end
