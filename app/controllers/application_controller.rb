class ApplicationController < ActionController::Base
  layout :layout_by_resource
  http_basic_authenticate_with name: 'bandit', password: 'smokey'

  protect_from_forgery

  before_filter do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  def after_sign_in_path_for(resource)
    sign_in_url = new_user_session_url
    return stored_location_for(resource) if stored_location_for(resource).present?
    return landing_path
  end

  def after_update_path_for(resource)
    redirect_to :back
  end

  def not_found
    fail ActionController::RoutingError.new('Not Found')
  end

  def layout_by_resource
    if devise_controller? || (controller_name == 'users' && action_name != 'show')
      'users'
    elsif controller_name == 'home'
      'home'
    else
      'building'
    end
  end

  def membership_landing_url(membership)
    case membership.membership_type
      when Membership::MEMBERSHIP_TYPE_GUEST, Membership::MEMBERSHIP_TYPE_TENANT
        building_path(membership.building)
      when Membership::MEMBERSHIP_TYPE_VENDOR
        vendor_membership_path
      when Membership::MEMBERSHIP_TYPE_MANAGER, Membership::MEMBERSHIP_TYPE_LANDLORD
        manage_buildings_path
     end
  end

end
