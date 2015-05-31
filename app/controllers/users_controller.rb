class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :get_community, only: [:show]

  def home
  end

  def show
    @user = User.find(params[:id])
  end

  private

  def get_community
    @community = Community.friendly.find(params[:community_id])
  end

end
