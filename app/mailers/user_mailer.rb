class UserMailer < ApplicationMailer

  def alert(notification)
    @sender_name = notification.notifiable.user.public_name
    @receipient_name = notification.user.public_name
    @community_name = notification.notifiable.community.public_name
    @url = Rails.application.routes.url_helpers.community_alert_url(notification.notifiable.community,
								    notification.notifiable,
								    host: "http://www.upstairs.io")
    @alert_text = notification.notifiable.message
    mail(to: notification.user.email,
	 subject: "Upstairs.io Coummunity Alert: #{notification.notifiable.message}" )
  end

  def post(notification)
    @sender_name = notification.notifiable.user.public_name
    @receipient_name = notification.user.public_name
    @community_name = notification.notifiable.postable.public_name
    @url = Rails.application.routes.url_helpers.community_post_url(notification.notifiable.postable,
								   notification.notifiable,
								   host: "http://www.upstairs.io")
    @post_title = notification.notifiable.title
    mail(to: notification.user.email,
	 subject: "#{notification.notifiable.user.public_name} posted #{notification.notifiable.title}" )
  end

  def comment(notification)
    @sender_name = notification.notifiable.user.public_name
    @receipient_name = notification.user.public_name
    @community_name = notification.notifiable.commentable.postable.public_name
    @url = Rails.application.routes.url_helpers.community_post_url(notification.notifiable.commentable.postable,
								   notification.notifiable.commentable,
								   host: "http://www.upstairs.io")
    @comment_text = notification.notifiable.body
    mail(to: notification.user.email,
	 subject: "#{notification.notifiable.user.public_name} commented on #{notification.notifiable.commentable.title}" )
  end

  def reply(notification)
    @sender_name = notification.notifiable.user.public_name
    @receipient_name = notification.user.public_name
    @community_name = notification.notifiable.comment.commentable.postable.public_name
    @url = Rails.application.routes.url_helpers.community_post_url(notification.notifiable.comment.commentable.postable,
								    notification.notifiable,
								    host: "http://www.upstairs.io")
    @reply_text = notification.notifiable.body
    mail(to: notification.user.email,
	 subject: "#{notification.notifiable.user.public_name} replied to a comment on #{notification.notifiable.comment.commentable.title}" )
  end

  def classified(notification)
    @sender_name = notification.notifiable.user.public_name
    @receipient_name = notification.user.public_name
    @community_name = notification.notifiable.community.public_name
    @url = Rails.application.routes.url_helpers.community_classified_url(notification.notifiable.community,
								    notification.notifiable,
								    host: "http://www.upstairs.io")
    @classified_text = notification.notifiable.body
    mail(to: notification.user.email,
	 subject: "#{notification.notifiable.user.public_name} posted classified #{notification.notifiable.title}" )
  end

end
