require "json"
require "open-uri"

class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [:edit, :update, :complete, :ignore, :unignore, :invite_friend, :accept_invitation, :decline_invitation]

  def index
    # Tasks created by the current user for today
    @tasks = current_user.tasks.where(date: Date.today)
    # Find all TaskParticipant records where current_user is a participant
    participant_records = TaskParticipant.where(user_id: current_user.id)

    # Collect the tasks for which the user is participating, excluding their own tasks
    @participating_tasks = []
    participant_records.each do |participant_record|
      task = participant_record.task
      if task.user_id != current_user.id
        @participating_tasks << task
      end
    end
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
       # All accepted participants, including the creator if they are in the list
      participants = @task.task_participants.where(status: "accepted").map(&:user)

      # Add XP to each participant, including creator
      participants.each do |participant|
        participant.add_xp(@task.xp || 0)
      end

      redirect_to tasks_path, notice: "Congratulations, Quest '#{@task.name}' completed!"
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
