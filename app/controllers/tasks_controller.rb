class TasksController < ApplicationController

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to new_task_path,  notice: "Quest successfully created!"
    else
      render :new
    end
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, :daily, :xp)
  end
end
