class Task < ApplicationRecord
  validates :name, presence: true
  validates :xp, presence: true
end
