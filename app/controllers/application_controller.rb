class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to '/welcome', :alert => exception.message
  end

  def after_sign_in_path_for(resource)
    if session[:invitation_id].present?
      invitation = Invitation.find(session[:invitation_id])
      session[:invitation_id] = nil
      redirect_to community_path(invitation.community)
    end
    if resource.invitation_link.present?
      session[:invitation_link] = nil
      community = resource.communities.first
      redirect_to community_path(community) and return false  if community.present?
    end
    sign_in_url = new_user_session_url
    return stored_location_for(resource) || root_path
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

end
