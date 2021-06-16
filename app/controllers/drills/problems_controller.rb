class Drills::ProblemsController < ApplicationController
  def index
    drill = Drill.find(params[:drill_id])
    @problems = drill.problems.order(created_at: "ASC")
  end
end
