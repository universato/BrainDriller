class API::DrillsController < API::ApplicationController
  def index
    @drills = Drill.order(created_at: "DESC").page(params[:page]).per(2)
  end

  THRESHOLD_OF_PROBLEM_MASTERED = 2

  def show
    @current_user_id = current_user&.id
    @drill = Drill.find(params[:id])
    order = params[:rand] ? "RANDOM()" : :id
    if current_user && params[:past]
      set_problems_when_past
    else
      @problems = @drill.problems.order(order).limit(params[:num])
      if current_user
        @problem_map = UserProblemResult.where(user_id: current_user.id, problem_id: @problems.pluck(:id)).to_h{ [_1.problem_id, _1 ] }
      end
    end
  end

  # - resultがあるもの
  #  - current_streak >= 2
  #  - current_streak < 2
  # - resultがないもの。
  private def set_problems_when_past
    order = params[:rand] ? "RANDOM()" : :id
    drill_problem_ids = @drill.problems.pluck(:id)
    mastered_ids = UserProblemResult.where(user_id: current_user.id, problem_id: drill_problem_ids).where("current_streak >= 2").pluck(:problem_id)
    ids = (Set[*drill_problem_ids] - Set[*mastered_ids]).to_a
    @problems = Problem.where(id: ids).order(order).limit(params[:num])
    @problem_map = UserProblemResult.where(user_id: current_user.id, problem_id: @problems.map(&:id)).to_h{ [_1.problem_id, _1 ] }
  end

  def grade
    grade_personal_result(current_user) if current_user
  end

  private def grade_personal_result(user)
    drill_id = params[:drill_id].to_i

    drill_user_result = DrillUserResult.find_or_create_by(user: user, drill_id: drill_id)
    answer_paper = params[:answer_paper]
    problems = params[:problems]
    problems.each do |problem|
      problem_id = problem[:id]
      user_problem_result = UserProblemResult.find_or_create_by(user: user, problem_id: problem_id)
      user_problem_result.number_of_submissions += 1
      if answer_paper[problem_id.to_s] == problem[:correct_option]
        user_problem_result.number_of_correct_answers += 1
        user_problem_result.current_streak += 1
      else
        user_problem_result.current_streak = 0
      end
      user_problem_result.save!
    end

    update_number_of_problem_mastered(drill_id)
  end

  private def update_number_of_problem_mastered(drill_id)
    return unless current_user

    drill_id = drill_id.id if drill_id.is_a?(Drill)
    number_of_problem_mastered = 0
    problem_ids = Drill.find(drill_id).problems.pluck(:id)
    UserProblemResult.where(user: current_user, problem_id: problem_ids).each do |problem_result|
      if problem_result.current_streak >= THRESHOLD_OF_PROBLEM_MASTERED
        number_of_problem_mastered += 1
      end
    end
    drill_user_result = DrillUserResult.find_or_create_by(user: current_user, drill_id: drill_id)
    drill_user_result.number_of_problem_mastered = number_of_problem_mastered
    drill_user_result.save!
  end

  def mydrills
    drill_ids = DrillLike.where(user: current_user).pluck(:drill_id)
    @drills = Drill.find(drill_ids)
    @drill_user_result = DrillUserResult.where(drill: drill_ids, user: current_user).to_h{ [_1.drill_id, _1] }
  end
end
