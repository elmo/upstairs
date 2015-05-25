class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :notifiable, polymorphic: true
  after_create :deliver_later

  def deliver_later
    NotifyWorker.perform_in(2.seconds, self.id)
  end

  def deliver
    if notifiable.class.to_s == 'Post'
       user.receives_text_messages?  &&
	  TwilioMessage.new(user.phone,
			    "#{notifiable.user.public_name} posted #{notifiable.title} view here:\n" +
			    Rails.application.routes.url_helpers.community_post_url(
		               notifiable.postable,
			       notifiable,
			       host: "http://www.upstairs.io")
          ).deliver
          UserMailer.post(self).deliver
    elsif notifiable.class.to_s == 'Classified'
       user.receives_text_messages? &&
	 TwilioMessage.new(user.phone,
	   notifiable.title + "\n" +  Rails.application.routes.url_helpers.community_classified_url(
           notifiable.community,
	   notifiable,
	   host: "http://www.upstairs.io")
        ).deliver
        UserMailer.classified(self).deliver
    elsif notifiable.class.to_s == 'Alert'
       user.receives_text_messages? &&
	 TwilioMessage.new(user.phone,
	   notifiable.message  + "\n" +  Rails.application.routes.url_helpers.community_alert_url(
           notifiable.community,
	   notifiable,
	   host: "http://www.upstairs.io")
        ).deliver
        UserMailer.alert(self).deliver
    elsif notifiable.class.to_s == 'Comment'
      if notifiable.parent_comment_id.present?
        user.receives_text_messages?  &&
	  TwilioMessage.new(user.phone,
			    "#{notifiable.user.public_name} commented on #{notifiable.comment.commentable.title}:\n" +
			       Rails.application.routes.url_helpers.community_post_url(
		                 notifiable.comment.commentable.postable,
			         notifiable.comment.commentable,
			         host: "http://www.upstairs.io")
	  ).deliver
          UserMailer.reply(self).deliver
      else
        user.receives_text_messages? &&
	  TwilioMessage.new(user.phone,
			    "#{notifiable.user.public_name} commented on #{notifiable.commentable.title}:\n" +
			       Rails.application.routes.url_helpers.community_post_url(
		                  notifiable.commentable.postable,
				  notifiable.commentable,
				  host: "http://www.upstairs.io")
	  ).deliver
          UserMailer.comment(self).deliver
      end
     elsif notifiable.class.to_s == 'Message'
       user.receives_text_messages? &&
       notifiable.recipient.receives_text_messages? &&
         TwilioMessage.new(notifiable.recipient.phone,
           "Upstairs.io: #{notifiable.sender.public_name} has sent you a message" +
           Rails.application.routes.url_helpers.community_url(notifiable.community, host: "http://www.upstairs.com" ))
        MessageMailer.message(self.notifiable)
     else
       raise "unknown notifiable"
     end
   end
end
