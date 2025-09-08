require "json"
require "open-uri"

class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [:edit, :update, :complete, :ignore, :unignore, :invite_friend, :accept_invitation, :decline_invitation]

  def index
  # Tasks created by the current user
    @tasks = current_user.tasks.where(date: Date.today)

    # Pending invitations = tasks where current_user is invited but has not accepted yet
    @pending_invitations = current_user.partner_tasks.where(
      date: Date.today,
      duo: true,
      completed: false
    )

    # Partner quests already accepted (duo flipped to false after acceptance)
    @partner_tasks = current_user.partner_tasks.where(
      date: Date.today,
      duo: false
    )
  end

  def new
    @task = current_user.tasks.new
  end

  def create
    @task = current_user.tasks.new(task_params)
    @task.date = Date.today
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
      name: activity["activity"],
      description: "Type: #{activity["type"]} - Participants: #{activity["participants"]} #{activity["link"].present? ? " - Link: #{activity["link"]}" : ""}",
      xp: 20,
      date: Date.today
    )
    if @task.save
      redirect_to tasks_path, notice: "Quest successfully created!"
    else
      render :home, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: "Your task was successfully updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def complete
    if @task.update(completed: true)
      current_user.add_xp(@task.xp || 0)
      redirect_to tasks_path, notice: "Congratulations, You completed the quest '#{@task.name}'!"
    else
      redirect_to tasks_path, alert: "Could not complete the quest."
    end
  end

  def ignore
    if @task.update(ignored: true)
      redirect_to tasks_path, notice: "You freezed the quest '#{@task.name}'!"
    else
      redirect_to tasks_path
    end
  end

  def unignore
    if @task.update(ignored: false)
      redirect_to tasks_path, notice: "You unfreezed the quest '#{@task.name}'!"
    else
      redirect_to tasks_path
    end
  end

  # Invitation d'un ami
  def invite_friend
    friend = User.find(params[:friend_id])
    if @task.update(partner: friend, duo: true)
      redirect_to tasks_path, notice: "#{friend.username} has been invited to help!"
    else
      redirect_to tasks_path, alert: "Could not invite #{friend.username}."
    end
  end

  # Accept invitation
  def accept_invitation
    if @task.partner_id == current_user.id
      @task.update(duo: false) # hack: mark as accepted
      redirect_to tasks_path, notice: "Quest accepted!"
    else
      redirect_to tasks_path, alert: "You can't accept this quest."
    end
  end


  # Decline invitation
  def decline_invitation
    if @task.partner_id == current_user.id
      @task.update(partner_id: nil, duo: false) # reset partner & duo flag
      redirect_to tasks_path, notice: "Quest declined!"
    else
      redirect_to tasks_path, alert: "You can't decline this quest."
    end
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, :daily, :xp, :duo, :partner_id, :date)
  end

  def set_task
    @task = Task.find(params[:id])
  end
end
