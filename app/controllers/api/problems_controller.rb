class API::ProblemsController < ApplicationController
  def update
    problem = Problem.find(params[:id])

    problem.title = params[:title]
    problem.statement = params[:statement]
    problem.choices = params[:choices]
    problem.correct_option = params[:correct_option]
    problem.explanation = params[:explanation]
    problem.save
  end

  private def problem_params
    # params.require(:problem).permit(:title, :statement, :choices, :correct_option)
  end
end
