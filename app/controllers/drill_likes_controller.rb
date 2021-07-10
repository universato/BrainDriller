class DrillLikesController < ApplicationController
  before_action :logged_in_user

  def create
    drill = Drill.find(params[:drill_id])
    DrillLike.create(user: current_user, drill: drill)
    redirect_to drill
  end

  def destroy
    drill_like = DrillLike.find(params[:id])
    raise unless drill_like.user == current_user
    drill = Drill.find(drill_like.drill_id)
    drill_like.destroy
    redirect_to drill
  end
end
