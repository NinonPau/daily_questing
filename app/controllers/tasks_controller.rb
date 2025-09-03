class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [:complete]
  def index
    @tasks = current_user.tasks
  end

  def new
    @task = current_user.tasks.new
  end

  def create
    @task = current_user.tasks.new(task_params)
    if @task.save
      redirect_to new_task_path, notice: "Quest successfully created!"
    else
      render :new, status: :unprocessable_entity
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
    params.require(:task).permit(:name, :description, :daily, :xp)
  end

  def set_task
    @task = current_user.tasks.find(params[:id])
  end
end
