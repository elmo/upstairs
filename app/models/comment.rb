class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  belongs_to :actionable, polymorphic: true
  has_many :replies, class_name: 'Comment', foreign_key: 'parent_comment_id', dependent: :destroy
  has_many :notifications, as: :notifiable, dependent: :destroy
  validates_presence_of :user
  validates_presence_of :body
  belongs_to :comment, foreign_key: 'parent_comment_id'
  after_create :send_automated_message
  attr_accessor :sending_context

  SENDING_CONTEXT_LANDLORD = 'Landlord'
  SENDING_CONTEXT_MANAGER = 'Manager'
  SENDING_CONTEXT_VENDOR = 'Vendor'


  def building
    commentable.building
  end

  def create_notifications
    if commentable.present? && !%w(Ticket Event).include?(commentable.class.to_s)
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

  def send_automated_messages
    AutomatedMessage.new(self).deliver
  end

  private

  def create_actionable
    Activity.create(actionable: self, user: user, building: commentable.building)
  end
end
