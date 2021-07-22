class User < ApplicationRecord
  before_save { self.email = email.downcase }
  before_save { self.login_name = login_name.downcase }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise(
    :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable,
    :omniauthable, omniauth_providers: [:google_oauth2]
  )

  has_many :drills
  has_many :drill_likes, class_name: "DrillLike", dependent: :destroy
  has_many :submissions
  # has_many :problem_user_results, class_name: "ProblemUserResult", foreign_key: "user_id", dependent: :destroy
  has_many :problems, through: :problem_user_results

  validates :email, presence: true, uniqueness: { case_sensitive: false }, length: { in: 3..200 }

  # login_name_format = {
  #   with: /\A[a-z\d](?:[a-z\d]|-(?=[a-z\d]))*\z/i,
  #   message: 'は半角英数字と-（ハイフン）のみが使用できます 先頭と最後にハイフンを使用することはできません ハイフンを連続して使用することはできません'
  # }
  # login_name_format = {
  #   with: /\A[a-z](?:[a-z]|-(?=[a-z]))*\z/i,
  #   message: 'は半角の英小文字と半角数字と-（半角ハイフン）のみが使用できます 先頭と最後にハイフンを使用することはできません ハイフンを連続して使用することはできません'
  # }
  login_name_format = {
    with: /\A[a-z][a-z0-9]*\z/i,
    message: 'は半角の英小文字と数字のみ使用できます。ただし、数字始まりにすることはできません。'
  }

  validates :login_name,
    presence: true,
    length: {in: 1..30},
    uniqueness: {case_sensitive: false},
    format: login_name_format

  # validates :password, length: { minimum: 5 }

  mount_uploader :icon, IconUploader

  def self.from_omniauth(auth)
    # auth.class    # => OmniAuth::AuthHash
    # auth.provider # => "google_oauth2"
    # auth.uid      # => "123456789012345678901"
    # auth.info        # OmniAuth::AuthHash::InfoHash
    # auth.credentials # OmniAuth::AuthHash
    # auth.extra       # OmniAuth::AuthHash
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.login_name = auth.info.name
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.confirmed_at = Time.current
      # user.icon = auth.info.image
    end
  end

  def icon_path
    icon.to_s.presence || "default_icon"
  end
end
