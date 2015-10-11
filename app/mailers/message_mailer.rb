class MessageMailer < ApplicationMailer
  def send_message(m)
    @recipient_name = m.recipient.public_name
    @sender_name = m.sender.public_name
    @building_name = m.building.public_name
    @body = m.body
    @url = ShortUrl.for(Rails.application.routes.url_helpers.building_message_url(m.building, m))
    mail(to: m.recipient.email, subject: "#{@sender_name} has sent you a message on Upstairs.io")
  end
end
