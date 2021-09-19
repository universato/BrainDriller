class DrillLikesController < ApplicationController
  def create
    drill = Drill.find(params[:drill_id])
    DrillLike.create(user: current_user, drill: drill)
    redirect_to drill
  end

  def destroy
    drill_like = DrillLike.find(params[:id])
    unless drill_like.user == current_user
      raise StandardError.new("different between drill_like.user and current_user")
    end

    drill = Drill.find(drill_like.drill_id)
    drill_like.destroy
    redirect_to drill
  end
end
