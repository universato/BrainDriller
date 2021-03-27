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
  end
end
