class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  belongs_to :actionable, polymorphic: true
  has_many :replies, class_name: 'Comment', foreign_key: "parent_comment_id"
  has_many :notifications, as: :notifiable
  validates_presence_of :user
  belongs_to :comment, foreign_key: "parent_comment_id"
  after_create :create_notifications
  after_create :create_actionable
  has_paper_trail

  def grandparent
    (parent_comment_id.present?) ? comment.commentable : commentable
  end

  def create_notifications
    commentable.commenters.each { |user| Notification.create(notifiable: self, user: user) } if commentable.present?
  end

  def commenters
    replies.collect(&:user).uniq
  end

  def reply?
    parent_comment_id.present?
  end

  private

  def create_actionable
   Activity.create(actionable: self, user: self.user, community: self.grandparent.postable)
  end

end
