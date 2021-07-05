class ProblemsController < ApplicationController
  def index
    @all_problem_size = Problem.count
    if current_user
      @problems = current_user.problems.order(created_at: "ASC").includes(:problem_user_results)
    else
      @problems = Problem.order(created_at: "ASC").page(params[:page])
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
