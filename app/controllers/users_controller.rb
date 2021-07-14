class UsersController < ApplicationController
  def show
    @user = User.find_by!(id: params[:id]) || User.find_by!(login_name: params[:id])
    @problem_user_results = []

    @drills = @user.drills
  end
end
