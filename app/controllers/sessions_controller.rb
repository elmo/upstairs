class SessionsController < Devise::SessionsController

  def new
    super
  end

  def create
    user = User.find_by_email(params[:user][:email])

    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_flashing_format?
    sign_in(resource_name, resource)

    yield resource if block_given?

    if session[:invitation_code].present?
      invitation = Invitation.find_by_token(session[:invitation_code])
      resource.invitation = invitation
      resource.apply_invitation
      redirect_to community_path(invitation.community)
    else
      respond_with resource, location: after_sign_in_path_for(resource)
    end

  end

end
