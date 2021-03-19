class API::ProblemsController < ApplicationController
  def index
    @drills = Drill.order(created_at: "DESC").page(params[:page])
    @drills = Drill.order(created_at: "DESC")
  end
end
