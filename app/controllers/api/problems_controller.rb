class API::ProblemsController < ApplicationController
  def index
    tsukawareteruno?
    @drills = Drill.order(created_at: "DESC").page(params[:page])
    @drills = Drill.order(created_at: "DESC")
  end

  def show
    @problem = Problem.find(params[:id])
  end

  def update
    @problem = Problem.find(params[:id])

    @problem.title = params[:title]
    @problem.statement = params[:statement]
    @problem.choices = params[:choices]
    @problem.correct_option = params[:correct_option]
    @problem.save
  end

  private def problem_params
    # params.require(:problem).permit(:title, :statement, :choices, :correct_option)
  end
end
