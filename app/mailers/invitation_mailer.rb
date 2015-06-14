class InvitationMailer < ApplicationMailer

  def invite(invitation)
    @sender_name = invitation.user.public_name
    @community_name = invitation.community.public_name
    @url = Rails.application.routes.url_helpers.community_invitation_redeem_url(invitation.community, invitation)
    mail(to: invitation.email, subject: "#{@sender_name} has invited you to join Upstairs.io")
  end

end

