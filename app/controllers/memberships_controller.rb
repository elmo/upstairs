class MembershipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_building, only: [:create,:destroy,:index]
  layout 'building'

  def create
    current_user.join(@building)
    redirect_to @building
  end

  def destroy
    current_user.leave(@building)
    redirect_to user_home_path
  end

  def index
    @memberships = @building.memberships.page(params[:page]).per(10)
  end

  private

  def set_building
    @building = Building.friendly.find(params[:building_id])
  end


end
