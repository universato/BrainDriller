class User < ApplicationRecord
  before_save { self.email = email.downcase }
  before_save { self.login_name = login_name.downcase }

  devise(
    :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable,
    :omniauthable, omniauth_providers: [:google_oauth2]
  )

  has_many :drills
  has_many :drill_likes, class_name: "DrillLike", dependent: :destroy
  has_many :submissions
  has_many :problems, through: :problem_user_results

  validates :email, presence: true, uniqueness: { case_sensitive: false }, length: { in: 3..200 }

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
    unless auth.info.has_key?("email_verified")
      set_flash_message(:alert, 'メールアドレスが認証されていません')
      redirect_to new_user_registration_url
    end

    User.where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
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
