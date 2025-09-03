class User < ApplicationRecord
  has_many :tasks
  has_one :user_mood
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable



  def add_xp(amount)
    current_total = total_xp || 0
    update(total_xp: current_total + amount.to_f) #
  end
end
