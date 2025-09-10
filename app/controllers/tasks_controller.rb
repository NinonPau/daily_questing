require "json"
require "open-uri"

class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [:edit, :update, :complete, :ignore, :unignore, :invite_friend, :accept_invitation, :decline_invitation]

  def index
    # Tasks created by the current user for today
    @tasks = current_user.tasks.where(date: Date.today)

    # Tasks where current_user is a participant (accepted or pending)
    participant_records = current_user.task_participants.where(status: ["pending", "accepted"])

    # Collect tasks for which the user is participating, including their own tasks
    @participating_tasks = participant_records.map(&:task)
  end

  def new
    @task = current_user.tasks.new
  end

  def create
    @task = current_user.tasks.new(task_params)
    @task.date = Date.today
    if @task.save
      @task.add_creator_as_participant
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
      redirect_to edit_task_path(@task), notice: "Your task was successfully updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def complete
    @task = Task.find(params[:id])

    # Mark the task as completed
    @task.update(completed: true)

    # Ensure creator is included as a participant
    @task.add_creator_as_participant

    # Give XP to all accepted participants
    @task.task_participants.where(status: "accepted").each do |tp|
      tp.user.add_xp(@task.xp.to_i)
    end

    redirect_to tasks_path, notice: "Quest completed!"
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


  def invite_friend
    friend = User.find(params[:friend_id])
    tp = @task.task_participants.find_or_initialize_by(user: friend)
    tp.status = "pending"
    if tp.save
      redirect_to tasks_path, notice: "#{friend.username} has been invited!"
    else
      redirect_to tasks_path, alert: "Could not invite #{friend.username}."
    end
  end


  def accept_invitation
    tp = @task.task_participants.find_by(user: current_user)
    if tp&.update(status: "accepted")
      redirect_to tasks_path, notice: "Quest accepted!"
    else
      redirect_to tasks_path, alert: "You can't accept this quest."
    end
  end



  def decline_invitation
    task = Task.find(params[:id])
    tp = @task.task_participants.find_by(user: current_user)
    if tp&.update(status: "declined")
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
