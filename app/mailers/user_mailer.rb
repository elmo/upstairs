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

end
