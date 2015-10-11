class InvitationMailer < ApplicationMailer
  def invite(invitation)
    @sender_name = invitation.user.public_name
    @building_name = invitation.building.public_name
    @url = Rails.application.routes.url_helpers.building_invitation_redeem_url(invitation.building, invitation)
    mail(to: invitation.email, subject: "#{@sender_name} has invited you to join Upstairs.io")
  end
end
