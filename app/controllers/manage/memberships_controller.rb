class Manage::MembershipsController < ApplicationController

  def index
    if params[:building_id].present?
      @building = Building.friendly.where(slug: params[:building_id]).first
      scope = @building.memberships
      if params[:membership_type]
        scope = scope.guest if params[:membership_type] == Membership::MEMBERSHIP_TYPE_GUEST
        scope = scope.tenant if params[:membership_type] == Membership::MEMBERSHIP_TYPE_TENANT
        scope = scope.manager if params[:membership_type] == Membership::MEMBERSHIP_TYPE_MANAGER
      end
      members = scope.collect(&:user)
      @members = Kaminari.paginate_array(members).page(params[:page]).per(5)
    else
      members = User.managed_by(user: current_user, membership_type: params[:membership_type] )
      @members = Kaminari.paginate_array(members).page(params[:page]).per(5)
    end
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
