class API::DrillLikesController < API::ApplicationController
  def destroy
    current_user.drill_likes.find_by(drill_id: params[:id]).destroy
  end
end
