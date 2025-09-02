require "json"
require "open-uri"

class TasksController < ApplicationController
  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to new_task_path, notice: "Quest successfully created!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def random
    url = "https://bored.api.lewagon.com/api/activity"
    activity_serialized = URI.parse(url).read
    activity = JSON.parse(activity_serialized)
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, :daily, :xp)
  end
end
