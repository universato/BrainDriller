class API::DrillsController < API::ApplicationController
  def index
    @drills = Drill.order(created_at: "DESC").page(params[:page]).per(2)
  end

  def show
    @current_user_id = current_user.id
    @drill = Drill.find(params[:id])
    order = params[:rand] ? "RANDOM()" : :id
    if current_user && params[:past]
      ids = @drill.problems.pluck(:id)
      problem_map = UserProblemRelation.where(user_id: current_user.id, problem_id: ids).where("current_streak < 2").limit(params[:num])
      @problem_map = problem_map.to_h{ [_1.problem_id, _1 ] }
      @problems = Problem.where(id: problem_map.pluck(:problem_id)).order(order)
    else
      @problems = @drill.problems.order(order).limit(params[:num])
      if current_user
        @problem_map = UserProblemRelation.where(user_id: current_user.id, problem_id: @problems.pluck(:id)).to_h{ [_1.problem_id, _1 ] }
      end
    end
  end

  def grade
    answer_paper = params[:answer_paper]
    problems = params[:problems]
    problems.each do |problem|
      problem_id = problem[:id].to_s
      user_problem_relation = UserProblemRelation.find_or_create_by(user: current_user, problem_id: problem_id)
      user_problem_relation.number_of_submissions += 1
      if answer_paper[problem_id] == problem[:correct_option]
        user_problem_relation.number_of_correct_answers += 1
        user_problem_relation.current_streak += 1
      end
      user_problem_relation.save!
    end
  end
end
