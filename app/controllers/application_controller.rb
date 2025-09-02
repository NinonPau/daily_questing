class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?#step one to change automatique form of registration (+ username)

protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end # ajoute username to the formulaire 
  end
