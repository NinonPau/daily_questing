class ApplicationController < ActionController::Base
  include Pundit::Authorization

  before_action :configure_permitted_parameters, if: :devise_controller?#step one to change automatique form of registration (+ username)
  before_action :reset_daily_tasks

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end # add username to the form

  private

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end

  def reset_daily_tasks
    any_today = Task.find_by(created_at: Time.zone.today.beginning_of_day..Time.zone.today.end_of_day)
  # check if a task have been created today (add daily if we want to reconduct random/other task)
  # first_daily_task = Task.find_by(daily: true)
  # if first_daily_task.nil? || first_daily_task.created_at.to_date != Date.today
  #   Task.reset_for_today
  # end

    if any_today.nil?
      Task.reset_for_today
    end
  end

end
