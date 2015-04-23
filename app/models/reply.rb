class Reply < Comment

  def commenters
    comment.commenters
  end

  def create_notifications
    comment.commenters.each { |user| Notification.create(notifiable: self, user: user) }
  end

end
