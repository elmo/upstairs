class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  belongs_to :actionable, polymorphic: true
  has_many :replies, class_name: 'Comment', foreign_key: "parent_comment_id", dependent: :destroy
  has_many :notifications, as: :notifiable, dependent: :destroy
  validates_presence_of :user
  belongs_to :comment, foreign_key: "parent_comment_id"
  after_create :create_notifications
  after_create :create_actionable
  has_paper_trail

  # TODO deprecate
  def grandparent
    (parent_comment_id.present?) ? comment.commentable : commentable
  end

  def community
    return commentable.community if commentable.class.to_s == 'Ticket'
    return (reply?) ?  comment.commentable.community : commentable.community
  end

  def create_notifications
   if commentable.present? and commentable.class.to_s != 'Ticket'
      commentable.commenters.each { |user| Notification.create(notifiable: self, user: user) }
   else
      commentable.community.users.each { |user| Notification.create(notifiable: self, user: user) }
   end
  end

  def commenters
    replies.collect(&:user).uniq
  end

  def reply?
    parent_comment_id.present?
  end

  def owned_by?(user)
    user_id == user.id
  end

  private

  def create_actionable
   if commentable.present? and commentable.class.to_s != 'Ticket'
    Activity.create(actionable: self, user: self.user, community: self.grandparent.postable)
   else
    Activity.create(actionable: self, user: self.user, community: self.commentable.community) if !reply?
   end
  end

end
