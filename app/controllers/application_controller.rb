class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  def after_sign_in_path_for(resource)
    if session[:invitation_id].present?
      invitation = Invitation.find(session[:invitation_id])
      session[:invitation_id] = nil
      redirect_to building_path(invitation.building)
    end
    if resource.invitation_link.present?
      session[:invitation_link] = nil
      building = resource.buildings.first
      redirect_to building_path(building) and return false  if building.present?
    end
    sign_in_url = new_user_session_url
    return stored_location_for(resource) || root_path
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

end
