class DrillsController < ApplicationController
  def index
    # @drills = Drill.order(created_at: "DESC").page(params[:page])
    @drills = Drill.order(created_at: "DESC").page(params[:page]).includes(:problems, :user)
  end

  def show
    @drill = Drill.find_by(id: params[:id])
    @drill.increment!(:number_of_views, 1)
    impressionist(@drill, nil, unique: [:session_hash])
    # @problems = @drill.problems
  end

  def new
    authenticate_user!
  end

  def create
    render json: {}
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

  private def drill_params
    params.require(:drill).permit(:title, :guide)
  end
end
