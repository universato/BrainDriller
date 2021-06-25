class Drills::ProblemsController < ApplicationController

  # drill_idから、多のproblemsを持ってくる。
  # problemsとcurernt_use.id でひっかかる UserProblemResultsを持ってくる。
  def index
    drill = Drill.find(params[:drill_id])
    drill_id = drill.id

    if current_user
      @problems = drill.problems.order(created_at: "ASC").includes(:user_problem_results)
      @problem_map = UserProblemResult.where(user_id: current_user.id, problem_id: @problems.pluck(:id)).to_h{ [_1.problem_id, _1] }
    else
      @problems = drill.problems.order(created_at: "ASC")
    end
  end
end
