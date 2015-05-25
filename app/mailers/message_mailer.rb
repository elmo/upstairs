class MessageMailer < ApplicationMailer
  default_url_options[:host] =  "http://www.upstairs.io"
  def message(message)
    @recipient_name = message.recipient.public_name
    @sender_name = message.sender.public_name
    @community_name = message.community.public_name
    @message = message.body
    @url = Rails.application.routes.url_helpers.community_url(message.community, host:  "http://www.upstairs.io" )
    mail(to: message.email, subject: "#{@sender_name} has sent you a message on Upstairs.io")
  end

end

