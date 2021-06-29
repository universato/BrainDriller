class DrillsController < ApplicationController
  def index
    # @drills = Drill.order(created_at: "DESC").page(params[:page])
    # @drills = Drill.order(created_at: "DESC").page(params[:page]).includes(:problems, :user)
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
      if @problem_size == @number_of_problem_mastered
        @driill_is_mastered = true
      end
    end
  end

  def new
    authenticate_user!
  end

  def create
    drill_title = params[:drillTitle]
    drill_guide = params[:drillGuide]
    drill_guide = params[:drillGuide]

    Drill.create!(
      user: current_user,
      title: drill_title,
      guide: drill_guide,
      state: :full_open,
    )

    puts "\n" * 9
    p "before create"
    pp params
    puts "create"
    puts "\n" * 9
  end

  def edit
    @drill = Drill.find(params[:id])
  end

  def update
    @drill = Drill.find(params[:id])
    @drill.update(drill_params)
    redirect_to "/drills/#{params[:id]}"
  end

  def solve
    render layout: 'logo_only'
  end

  def mydrills
  end

  private def drill_params
    params.require(:drill).permit(:title, :guide)
  end
end
