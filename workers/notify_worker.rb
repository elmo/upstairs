class NotifyWorker
  include Sidekiq::Worker

  def perform(notification_id)
    @notification = Notification.find(notification_id)
    @notification.deliver
  end
end
