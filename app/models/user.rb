class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_many :drills
  has_many :drill_likes, class_name: "DrillLike", foreign_key: "user_id", dependent: :destroy
  has_many :submissions
  # has_many :problem_user_results, class_name: "ProblemUserResult", foreign_key: "user_id", dependent: :destroy
  has_many :problems, through: :problem_user_results

  validates :email, presence: true, uniqueness: true, length: { in: 3..200 }
  validates :login_name, presence: true, length: { in: 1..30 }, uniqueness: true
  # validates :password, length: { minimum: 5 }

  mount_uploader :icon, IconUploader

  def icon_path
    icon.to_s.presence || "default_icon"
  end

  def to_s
    login_name
  end
end
