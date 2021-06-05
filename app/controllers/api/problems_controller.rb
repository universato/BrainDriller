class API::ProblemsController < ApplicationController
  def index
    tsukawareteruno?
    @drills = Drill.order(created_at: "DESC").page(params[:page])
    @drills = Drill.order(created_at: "DESC")
  end

  def show
    @problem = Problem.find(params[:id])
  end
end
