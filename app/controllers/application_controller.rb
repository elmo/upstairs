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
    sign_in_url = new_user_session_url
    return stored_location_for(resource) if stored_location_for(resource).present?
    return welcome_path if resource.brand_new?
    return buildings_path if resource.welcomed? and !resource.building_chosen?
    if resource.primary_residence.present?
      return building_path(resource.primary_residence)
    end
    root_path
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
