class MembershipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_community, only: [:create,:destroy]

  def create
    current_user.join(@community)
    redirect_to @community
  end

  def destroy
    current_user.leave(@community)
    redirect_to user_home_path
  end

  private

  def set_community
    @community = Community.friendly.find(params[:community_id])
  end


end
