class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # callback for google
  def google_oauth2
    callback_for(:google)
    puts "\n" * 4
    puts "google_oauth2"
  end

  def callback_for(provider)
    # auth = request.env["omniauth.auth"]
    # クラスは、OmniAuth::AuthHash
    # この中にgoogoleアカウントから取得したメールアドレスや、名前と言ったデータが含まれています
    # keyが, "provider", "uid", ""
    # sliceで、シンボルでも文字列でも取れるし、メソッド形式でもとれる。

    @user = User.from_omniauth(request.env["omniauth.auth"])
    if @user.persisted?
      # sign_in_and_redirect @user, event: :authentication # this will throw if @user is not activated
      sign_in @user
      set_flash_message(:notice, :success, kind: provider.to_s.capitalize) if is_navigational_format?
      redirect_to root_path
    else
      # Removing extra as it can overflow some session stores
      session["devise.google_data"] = request.env["omniauth.auth"].except("extra")
      redirect_to new_user_registration_url
    end
  end

  def failure
    redirect_to root_path
  end
end
