class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]

  def index
    @users = User.page(params[:page]).per(15)
  end

  def show
    @user = User.find_by!(id: params[:id]) || User.find_by!(login_name: params[:id])
    @problem_user_results = []

    @drills = @user.drills
  end

  def edit_profile
    authenticate_user!
  end
end
