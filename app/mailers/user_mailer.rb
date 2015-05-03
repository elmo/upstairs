class UserMailer < ApplicationMailer

  def alert(notification)
    @sender_name = notification.user.public_name
    @receipient_name = notification.notifiable.user.public_name
    @community_name = notification.notifiable.community.public_name
    @url = Rails.application.routes.url_helpers.community_alert_url(notification.notifiable.community, notification.notifiable, host: "http://www.upstairs.io")
    @alert_text = notification.notifiable.message
    mail(to: notification.notifiable.user.email, subject: "Upstairs.io Coummunity Alert:" )
  end
end
