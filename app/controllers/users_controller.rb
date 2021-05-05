class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]

  def index
    @users = User.page(params[:page]).per(15)
  end

  def submissions
    @user = User.find(params[:id])
    @submissions = @user.submissions
  end

  def show
    @user = User.find_by(id: params[:id]) || User.find_by(login_name: params[:id])
    @user_problem_relations = []

    @drills = @user.drills


    # @problems = @user.problems
    # @problems.each do |problem|
    #   @user_problem_relations << UserProblemRelation.find_by(user_id: @user.id, problem_id: problem.id)
    # end
  end

  def edit_profile
    authenticate_user!
  end
end
