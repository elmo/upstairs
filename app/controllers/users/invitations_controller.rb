class Users::InvitationsController < Devise::InvitationsController

  def new
    self.resource = resource_class.new
    self.resource.invitation_type = params[:invitation_type]
    render template: "/users/invitations/manager/new"
  end

  def create
    self.resource = invite_resource
    resource_invited = resource.errors.empty?

    yield resource if block_given?

    if resource_invited
      if is_flashing_format? && self.resource.invitation_sent_at
        set_flash_message :notice, :send_instructions, :email => self.resource.email
      end
      respond_with resource, :location => after_invite_path_for(current_inviter)
    else
      respond_with_navigational(resource) { render :new }
    end
  end

  private
  # this is called when creating invitation
  # should return an instance of resource class
  def invite_resource
    ## skip sending emails on invite
    super do |u|
      u.skip_invitation = true
      u.invitation_type = params[:user][:invitation_type]
    end
  end

  # this is called when accepting invitation
  # should return an instance of resource class
  def accept_resource
    resource = resource_class.accept_invitation!(update_resource_params)
    resource
  end
end
