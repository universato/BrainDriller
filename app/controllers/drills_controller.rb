class DrillsController < ApplicationController
  def index
    @drills = Drill.order(created_at: "DESC").page(params[:page])
  end

  def show
    @drill = Drill.find_by(id: params[:id])
    @drill.increment!(:number_of_views, 1)
    @problems = @drill.problems
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
  end

  def solve
  end

  private
    def drill_params
      params.require(:drill).permit(:title)
    end
end
