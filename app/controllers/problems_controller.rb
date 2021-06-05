class ProblemsController < ApplicationController
  def index
    if current_user
      @all_problem_size = Problem.count
      @problems = current_user.problems.includes(:user_problem_relations)
    else
      @all_problem_size = Problem.count
      @problems = Problem.order(created_at: "DESC").page(params[:page])
    end
  end

  def show
    @problem = Problem.find(params[:id])
  end

  def edit
    @problem = Problem.find(params[:id])
  end

  def favorite
    current_links
  end
end
