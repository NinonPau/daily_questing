require "json"
require "open-uri"

class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [:complete]

  def index
    @tasks = current_user.tasks.where(date: Date.today) # print only the task of today
  end

  def new
    @task = current_user.tasks.new
  end

  def create
    @task = current_user.tasks.new(task_params)
    @task.date = Date.today # Automatically set today's date when created, even if daily, to make it appear in list
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
      xp: 20,
      date: Date.today)
    if @task.save
      redirect_to tasks_path, notice: "Quest successfully created!"
    else
      render :home, status: :unprocessable_entity
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      redirect_to tasks_path, notice:"Your task was successfully updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def complete
    @task = current_user.tasks.find(params[:id])
    if @task.update(completed: true)
      current_user.add_xp(@task.xp || 0)
      redirect_to tasks_path, notice: "You completed the quest '#{@task.name}'!"
    else
      redirect_to tasks_path, alert: "Could not complete the quest."
    end
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, :daily, :xp, :date)
  end

  def set_task
    @task = current_user.tasks.find(params[:id])
  end
end
