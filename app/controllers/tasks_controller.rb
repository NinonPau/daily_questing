require "json"
require "open-uri"

class TasksController < ApplicationController
  def index
    @tasks = Task.all
  end

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
    @task = Task.new(name: activity["activity"], description: "Type of quest: #{activity["type"]} - Number of participants recommended: #{activity["participants"]}")
    raise
    if @task.save
      redirect_to tasks_path, notice: "Quest successfully created!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, :daily, :xp)
  end
end
