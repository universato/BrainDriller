class Drills::ProblemsController < ApplicationController
  # drill_idから、多のproblemsを持ってくる。
  # problemsとcurernt_use.id でひっかかる ProblemUserResultsを持ってくる。
  def index
    drill = Drill.find(params[:drill_id])

    if current_user
      @problems = drill.problems.order(created_at: "ASC").includes(:problem_user_results)
      @problem_map = ProblemUserResult.where(
        user_id: current_user.id,
        problem_id: @problems.pluck(:id)
      ).to_h{ [_1.problem_id, _1] }
    else
      @problems = drill.problems.order(created_at: "ASC")
    end
  end
end
