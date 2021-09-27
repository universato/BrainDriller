class DrillsController < ApplicationController
  def index
    @drills = Drill.order(created_at: "DESC").page(params[:page]).where(state: :full_open).includes(:problems, :user)
  end

  def show
    @drill = Drill.find_by(id: params[:id])
    @drill.increment!(:number_of_views, 1)
    impressionist(@drill, nil, unique: [:session_hash])
    @problems = @drill.problems
    @problem_size = @problems.size

    if current_user
      @drill_user_result = DrillUserResult.find_by(user: current_user, drill: @drill)
      @number_of_problem_mastered = @drill_user_result&.number_of_problem_mastered
      @driill_is_mastered = true if @problem_size == @number_of_problem_mastered
    end
  end

  def new
    authenticate_user!
    redirect_to root_path unless current_user&.admin?
  end

  def create
    return unless current_user&.admin?

    drill = Drill.new(
      user: current_user,
      title: params[:drillTitle],
      guide: params[:drillGuide],
      state: :draft,
    )

    if drill.save
      json = {
        status: 200,
        message: "Success #{controller_name.capitalize} #{action_name.capitalize}",
        redirect_edit_url: "/drills/#{drill[:id]}/edit"
      }
      render status: 200, json: json
    else
      json = {
        status: 400,
        message: "Bad request #{controller_name.capitalize} #{action_name.capitalize}",
        redirect_edit_url: "/drills/new"
      }
      render status: 400, json: json
    end
  end

  def edit
    authenticate_user!
    @drill = Drill.find(params[:id])
    redirect_to root_path unless @drill.user == current_user || current_user&.admin?
  end

  def update
    return unless current_user&.admin?

    @drill = Drill.find_by(id: params[:id], user: current_user)
    @drill.title = params[:drillTitle]
    @drill.guide = params[:drillGuide]
    @drill.state = params[:drillState]
    @drill.save

    params[:problems].each do |problem_param|
      problem = Problem.find_or_create_by(id: problem_param[:id])
      problem.user ||= current_user
      problem.drill_id ||= @drill[:id]
      problem.title = problem_param[:title]
      problem.statement = problem_param[:statement]
      problem.format = "basic_choices"
      problem.choices = problem_param[:choices]
      problem.correct_option = 1
      problem.explanation = problem_param[:explanation] || ""
      problem.save!
    end
  end

  def solve
    render layout: 'logo_only'
  end
end
