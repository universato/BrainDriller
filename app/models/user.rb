class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_many :submissions
  has_many :microposts
  has_many :user_problem_relations, class_name: "UserProblemRelation", foreign_key: "user_id", dependent: :destroy
  has_many :problems, through: :user_problem_relations
end
