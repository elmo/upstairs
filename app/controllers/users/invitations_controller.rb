class Users::InvitationsController < Devise::InvitationsController

  def new
    self.resource = resource_class.new
    self.resource.invitation_type = params[:invitation_type].capitalize
    self.resource.invited_to_building = params[:building_id]
    render template: "/users/invitations/manager/new"
  end

  private

  def invite_resource
    super do |u|
      #u.skip_invitation = true
      u.invitation_type = params[:user][:invitation_type].capitalize
      u.invited_to_building_id = params[:user][:invited_to_building_id]
    end
  end

  def after_invite_path_for(current_inviter)
    if current_inviter.landlord? or current_inivter.manager?
      manage_invitations_path
    elsif current_inviter.vendor?
        vendor_buildings_path
    elsif current_inviter.tenant? or current_inviter.guest?
      if resource.invited_to_building.present?
        building_path(resource.invited_to_building)
      else
        buildings_path
      end
    end
  end

  def accept_resource
    resource = resource_class.accept_invitation!(update_resource_params)
    return resource if resource.invitation_type.blank?
    case resource.invitation_type
     when Membership::MEMBERSHIP_TYPE_MANAGER
       resource.invited_by.owned_and_managed_properties.each { |building| resource.make_manager(building) }
     when Membership::MEMBERSHIP_TYPE_VENDOjR
       resource.invited_by.owned_and_managed_properties.each { |building| resource.make_vendor(building) }
     when Membership::MEMBERSHIP_TYPE_TENANT
        resource.make_tenant(resource.invited_to_building)
     else
        resource.make_guest(resource.invited_to_building)
    end
    resource
  end

  def after_accept_path_for(resource)
     case resource.invitation_type
       when Membership::MEMBERSHIP_TYPE_MANAGER, Membership::MEMBERSHIP_TYPE_VENDOR
         manage_buildings_path
       when Membership::MEMBERSHIP_TYPE_TENANT, Membership:: MEMBERSHIP_TYPE_GUEST
         if resource.invited_to_building.present?
           building_path(resource.invited_to_building)
         else
           buildings_path
        end
       else
        root_path
     end
  end
end
