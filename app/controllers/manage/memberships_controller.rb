class Manage::MembershipsController < ApplicationController

  def index
    membership_type = params[:membership_type]
    if params[:building_id].present?
       @building = Building.friendly.where(slug: params[:building_id]).first
       scope = User.managed_by_with_membership_type_within_building(current_user, membership_type, @building.id) if membership_type.present?
       scope = User.managed_by_within_building(current_user, @building.id) unless membership_type.present?
     else
       scope = User.managed_by_with_membership_type(current_user, membership_type) if membership_type.present?
       scope = User.managed_by(current_user) unless membership_type.present?
    end
    @users = scope.page(params[:page]).per(5)
  end

  def destroy
    @building = Building.friendly.where(slug: params[:building_id]).first
    if @building.present? and current_user.landlord_or_manager_of?(@building)
      @membership = @building.memberships.find(params[:id])
      @membership.destroy
      redirect_to :back
    end
  end

  def show
    @user = User.find_by(slug: params[:id])
  end

end
