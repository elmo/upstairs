class UserMailer < ApplicationMailer

  def alert(notification)
    @sender_name = notification.notifiable.user.public_name
    @recipient_name = notification.user.public_name
    @building_name = notification.notifiable.building.public_name
    @url = ShortUrl.for(Rails.application.routes.url_helpers.building_alert_url(notification.notifiable.building, notification.notifiable))
    @alert_text = notification.notifiable.message
    mail(to: notification.user.email, subject: "Upstairs.io Coummunity Alert: #{notification.notifiable.message}")
  end

  def post(notification)
    @sender_name = notification.notifiable.user.public_name
    @recipient_name = notification.user.public_name
    @building_name = notification.notifiable.postable.public_name
    @url = ShortUrl.for(Rails.application.routes.url_helpers.building_post_url(notification.notifiable.postable, notification.notifiable))
    @post_title = notification.notifiable.title
    mail(to: notification.user.email, subject: "#{notification.notifiable.user.public_name} posted #{notification.notifiable.title}")
  end

  def comment(notification)
    @sender_name = notification.notifiable.user.public_name
    @recipient_name = notification.user.public_name
    @building_name = notification.notifiable.commentable.postable.public_name
    @url = ShortUrl.for(Rails.application.routes.url_helpers.building_post_url(notification.notifiable.commentable.postable, notification.notifiable.commentable))
    @comment_text = notification.notifiable.body
    mail(to: notification.user.email, subject: "#{notification.notifiable.user.public_name} commented on #{notification.notifiable.commentable.title}")
  end

  def reply(notification)
    @sender_name = notification.notifiable.user.public_name
    @recipient_name = notification.user.public_name
    @building_name = notification.notifiable.comment.commentable.postable.public_name
    @url = ShortUrl.for(Rails.application.routes.url_helpers.building_post_url(notification.notifiable.comment.commentable.postable, notification.notifiable))
    @reply_text = notification.notifiable.body
    mail(to: notification.user.email, subject: "#{notification.notifiable.user.public_name} replied to a comment on #{notification.notifiable.comment.commentable.title}")
  end

  def verification_request_approved(verification_request)
    @building = verification_request.building
    @user = verification_request.user
    @email = @user.email
    @building_url = Rails.application.routes.url_helpers.building_url(@building)
    mail(to: @email, from: "admin@upstairs.io", subject: "Your Upstairs verfication request for #{@building.address} has been approved!" )
  end

  def verification_request_rejected(verification_request)
    @building = verification_request.building
    @user = verification_request.user
    @email = @user.email
    @building_url = Rails.application.routes.url_helpers.building_url(@building)
    mail(to: @email, from: "admin@upstairs.io", subject: "You're to be offical Upstairs landlord of #{@building.address} been rejected." )
  end

  def verification_expired(verification)
    @building = verification.building
    @user = verification.user
    @email = @user.email
    @building_url = Rails.application.routes.url_helpers.building_url(@building)
    mail(to: @email, from: "admin@upstairs.io", subject: "You are no longer the offical Upstairs landlord of #{@building.address}." )
  end

end
