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

  def building
    commentable.building
  end

  def create_notifications
   if commentable.present? and !['Ticket', 'Event'].include?(commentable.class.to_s)
      commentable.commenters.each { |user| Notification.create(notifiable: self, user: user) }
   else
      commentable.building.users.each { |user| Notification.create(notifiable: self, user: user) }
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
    Activity.create(actionable: self, user: self.user, building: self.commentable.building)
  end

end
