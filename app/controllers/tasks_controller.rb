require "json"
require "open-uri"

class TasksController < ApplicationController
  before_action :authenticate_user!

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
    @task = current_user.tasks.new(
      user_id: current_user.id,
      name: activity["activity"],
      description: "Type of quest: #{activity["type"]} -
                    Number of participants recommended: #{activity["participants"]}
                    #{activity["link"] == "" ? "" : " - Link: #{activity["link"]}"}",
      xp: 20)
    if @task.save
      redirect_to tasks_path, notice: "Quest successfully created!"
    else
      render :home, status: :unprocessable_entity
    end
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, :daily, :xp)
  end
end
