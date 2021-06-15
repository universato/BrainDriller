class API::DrillsController < API::ApplicationController
  def index
    @drills = Drill.order(created_at: "DESC").page(params[:page]).per(2)
  end

  def show
    @drill = Drill.find(params[:id])
    if params[:rand]
      @problems = @drill.problems.order("RANDOM()").limit(params[:num])
    else
      @problems = @drill.problems.limit(params[:num])
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
