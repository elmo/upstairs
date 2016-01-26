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
      scope = scope.page(params[:page]).per(10)
      members = scope.collect(&:user)
      @members = Kaminari.paginate_array(members).page(params[:page]).per(10)
    else
      @members = User.managed_by(user: current_user, membership_type: params[:membership_type] )
    end
  end

end
