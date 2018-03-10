class FavoritesController < ApplicationController
  before_action :require_user_logged_in

  def create
    micropost = Micropost.find(params[:micropost_id])
    current_user.favor(micropost)
    flash[:success] = 'マイクロポストをお気に入りにしました。'
    redirect_back(fallback_location: root_path)
  end

  def destroy
    micropost = Micropost.find(params[:micropost_id])
    current_user.unfavor(micropost)
    flash[:warning] = 'マイクロポストをお気に入りから外しました。'
    redirect_back(fallback_location: root_path)
  end
end