class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :get_building, only: [:show]

  def landing
   @memberships = current_user.memberships.order(membership_type: :desc).page(params[:page]).per(20)
   redirect_to membership_landing_url(@memberships.first) if @memberships.count == 1
  end

  def welcome
  end

  def acknowledge
    current_user.profile_welcomed!
    redirect_to buildings_path
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

  def get_building
    @building = Building.friendly.find(params[:building_id])
  end
end
