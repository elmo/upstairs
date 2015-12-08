class ApplicationController < ActionController::Base
  layout :layout_by_resource
  #http_basic_authenticate_with name: 'upstairs', password: 'fixitnow'

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
    if session[:invitation_id].present?
      invitation = Invitation.find(session[:invitation_id])
      session[:invitation_id] = nil
      redirect_to building_path(invitation.building)
    end
    sign_in_url = new_user_session_url
    stored_location_for(resource) || root_path
  end

  def not_found
    fail ActionController::RoutingError.new('Not Found')
  end

  protected

  def layout_by_resource
    if devise_controller? or (controller_name == 'users' and action_name != 'show')
     'users'
    elsif controller_name == 'home'
      'home'
    else
     'building'
    end
  end

end
