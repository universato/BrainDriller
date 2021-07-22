class Admin::UsersController < ApplicationController
  before_action :if_not_admin

  def index
    @users = User.page(params[:page]).per(15)
  end

  def show
    if /\d+/.match?(params[:id])
      @user = User.find(params[:id])
    else
      @user = User.find_by(login_name: params[:id])
    end
  end

  private def if_not_admin
    redirect_to root_path unless current_user&.admin?
  end
end
