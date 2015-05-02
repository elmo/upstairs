class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :notifiable, polymorphic: true
  after_create :deliver_later

  def deliver_later
    NotifyWorker.perform_in(2.seconds, self.id)
  end

  def deliver
    if notifiable.class.to_s == 'Post'
    elsif notifiable.class.to_s == 'Alert'
       user.receives_text_messages? && TwilioMessage.new(user.phone,
			 notifiable.message  + "\n" +  Rails.application.routes.url_helpers.community_alert_url(
				 notifiable.community,notifiable,
				 host: "http://www.upstairs.io") ).deliver
       UserMailer.alert(self).deliver
    elsif notifiable.class.to_s == 'Comment'
      if notifiable.parent_comment_id.present?
         #p "notifying #{user.email} about Reply #{notifiable.body}"
      else
         #p "notifying #{user.email} about Comment #{notifiable.body}"
      end
     else
       #p "unknown notifiable"
     end
   end
end
