class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: "User"
  # say friend_id refer tu users tables not friend table

  validates :friend_id, presence: true
  validates :user_id, presence: true
  #  friendship belong to user
  validates :friend_id, uniqueness: true
  
end
