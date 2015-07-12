class Reply < Comment

  def building
    comment.commentable.building
  end

  def commenters
    comment.commenters
  end

  def create_notifications
    comment.commenters.each { |user| Notification.create(notifiable: self, user: user) }
  end

  def name
    "reply"
  end

end
