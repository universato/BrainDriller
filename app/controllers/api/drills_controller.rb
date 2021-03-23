class API::DrillsController < API::ApplicationController
  def index
    @drills = Drill.order(created_at: "DESC").page(params[:page]).per(2)
  end

  def show
    @drill = Drill.find(params[:id])
    @problems = @drill.problems.reorder("RANDOM()")
  end
end
