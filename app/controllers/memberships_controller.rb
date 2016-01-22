class MembershipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_building, only: [:create, :destroy, :index, :grant, :revoke]
  before_action :set_membership, only: [:grant, :revoke]
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

  def revoke
    current_user.revoke(@membership, params[:membership_type])
    redirect_to :back
  end

  def grant
    current_user.grant(@membership, params[:membership_type])
    redirect_to :back
  end

  private

  def set_building
    @building = Building.friendly.find(params[:building_id])
  end

  def set_membership
    @membership = Membership.find(params[:id])
  end
end
