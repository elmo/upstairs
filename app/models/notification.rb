class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :notifiable, polymorphic: true
  after_create :deliver_later

  def deliver_later
    NotifyWorker.perform_in(2.seconds, self.id)
  end

  def deliver
    if notifiable.class.to_s == 'Post'
     send_text_message(user, "#{notifiable.user.public_name} posted #{notifiable.title} view here:\n" + ShortUrl.for(Rails.application.routes.url_helpers.building_post_url( notifiable.postable, notifiable)))
     UserMailer.post(self).deliver
    elsif notifiable.class.to_s == 'Alert'
       send_text_message(user, notifiable.message  + "\n" +  ShortUrl.for(Rails.application.routes.url_helpers.building_alert_url( notifiable.building, notifiable)))
       UserMailer.alert(self).deliver
    elsif notifiable.class.to_s == 'Comment'
      if notifiable.parent_comment_id.present?
        send_text_message(user, "#{notifiable.user.public_name} commented on #{notifiable.comment.commentable.title}:\n" +
          ShortUrl.for(Rails.application.routes.url_helpers.building_post_url( notifiable.comment.commentable.postable, notifiable.comment.commentable)))
       UserMailer.reply(self).deliver
      else
        send_text_message(notifiable.user, "#{notifiable.user.public_name} commented on #{notifiable.commentable.title}:\n" +
	  ShortUrl.for(Rails.application.routes.url_helpers.building_post_url( notifiable.commentable.postable, notifiable.commentable)))
        UserMailer.comment(self).deliver
      end
     elsif notifiable.class.to_s == 'Message'
       send_text_message(notifiable.recipient, "Upstairs.io: #{notifiable.sender.public_name} has sent you a message.\n" +
                         ShortUrl.for(Rails.application.routes.url_helpers.building_message_url(notifiable.building, notifiable)))
       MessageMailer.send_message(self.notifiable).deliver
     else
       raise "unknown notifiable"
     end
   end

  def send_text_message(user,message)
    TwilioMessage.new(user.phone,message).deliver if user.receives_text_messages?
  end

end
