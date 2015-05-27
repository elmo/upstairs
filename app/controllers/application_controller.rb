class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to '/welcome', :alert => exception.message
  end

  def after_sign_in_path_for(resource)
    if session[:invitation_id].present?
      invitation = Invitation.find(session[:invitation_id])
      session[:invitation_id] = nil
      redirect_to community_path(@community)
    end
    sign_in_url = new_user_session_url
    if request.referer == sign_in_url
     return stored_location_for(resource) || root_path
    else
     return stored_location_for(resource) || root_path
    end
  end

end
