class User < ApplicationRecord
  has_many :tasks
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one :user_mood

  def add_xp(amount)
    current_total = total_xp || 0
    update(total_xp: current_total + amount.to_f * self.user_mood.xp_bonus)
  end

end
