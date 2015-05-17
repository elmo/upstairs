class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :postable, polymorphic: true
  belongs_to :actionable, polymorphic: true
  has_many :comments, as: :commentable
  has_many :notifications, as: :notifiable
  validates_presence_of :user
  validates_presence_of :title
  after_create :create_notifications
  after_create :create_actionable

  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged
  has_paper_trail
  has_attachments :photos

  def community
    postable
  end

  def commenters
    comments.collect(&:user).uniq
  end

  def create_notifications
    postable(includes: :user).users.each { |member| Notification.create(notifiable: self, user: member)  }
  end

  def slug_candidates
    [:title]
  end

  def grandparent
   self
  end

  def owned_by?(user)
    user_id == user.id
  end

  private

  def create_actionable
    Activity.create(actionable: self, user: self.user, community: self.postable)
  end

end
