class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  has_many :replies, class_name: 'Comment', foreign_key: "parent_comment_id"
  has_many :notifications, as: :notifiable
  validates_presence_of :user
  belongs_to :comment, foreign_key: "parent_comment_id"
  after_create :create_notifications
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

  def verb
    (reply?) ? " replied " : " commented "
  end

  def reply?
    parent_comment_id.present?
  end

end
