class TaskParticipant < ApplicationRecord
  belongs_to :task
  belongs_to :user
  validates :user_id, uniqueness: { scope: :task_id } # prevent duplicates
  validates :status, inclusion: { in: ["pending", "accepted", "declined"] }
end
