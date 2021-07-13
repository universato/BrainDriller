class User < ApplicationRecord
  before_save { self.email = email.downcase }
  before_save { self.login_name = login_name.downcase }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable

  has_many :drills
  has_many :drill_likes, class_name: "DrillLike", foreign_key: "user_id", dependent: :destroy
  has_many :submissions
  # has_many :problem_user_results, class_name: "ProblemUserResult", foreign_key: "user_id", dependent: :destroy
  has_many :problems, through: :problem_user_results

  validates :email, presence: true, uniqueness: { case_sensitive: false }, length: { in: 3..200 }

  # login_name_format = {
  #   with: /\A[a-z\d](?:[a-z\d]|-(?=[a-z\d]))*\z/i,
  #   message: 'は半角英数字と-（ハイフン）のみが使用できます 先頭と最後にハイフンを使用することはできません ハイフンを連続して使用することはできません'
  # }
  login_name_format = {
    with: /\A[a-z](?:[a-z]|-(?=[a-z]))*\z/i,
    message: 'は半角の英小文字と半角数字と-（半角ハイフン）のみが使用できます 先頭と最後にハイフンを使用することはできません ハイフンを連続して使用することはできません'
  }

  validates :login_name,
    presence: true,
    length: {in: 4..30},
    uniqueness: {case_sensitive: false},
    format: login_name_format

  # validates :password, length: { minimum: 5 }

  mount_uploader :icon, IconUploader

  def icon_path
    icon.to_s.presence || "default_icon"
  end

  def to_s
    login_name
  end
end
