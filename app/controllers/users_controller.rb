class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :get_community, only: [:show]

  def home
  end

  def show
    @user = User.where(slug: params[:id]).last
    if @user.landlord?
      render template: '/users/landlord'
    else
      render template: '/users/show'
    end
  end

  private

  def get_community
    @community = Community.friendly.find(params[:community_id])
  end

end
