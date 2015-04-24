class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :notifiable, polymorphic: true
  after_create :deliver_later

  def deliver_later
    NotifyWorker.perform_in(2.seconds, self.id)
  end

  def deliver
    if notifiable.class.to_s == 'Post'
      p "notifying #{user.email} about Post #{notifiable.title}"
    elsif notifiable.class.to_s == 'Comment'
      if notifiable.parent_comment_id.present?
         p "notifying #{user.email} about Reply #{notifiable.body}"
      else
         p "notifying #{user.email} about Comment #{notifiable.body}"
      end
     else
       p "unknown notifiable"
     end
   end
end
