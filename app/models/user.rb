class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_many :drills
  has_many :submissions
  has_many :user_problem_relations, class_name: "UserProblemRelation", foreign_key: "user_id", dependent: :destroy
  has_many :problems, through: :user_problem_relations

  validates :login_name, {presence: true, length: {maximum: 15}}
  validates :password, length: { minimum: 6 }

  def to_s
    login_name
  end
end
