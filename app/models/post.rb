class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  belongs_to :postable, polymorphic: true
  belongs_to :actionable, polymorphic: true
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :notifications, as: :notifiable, dependent: :destroy
  validates_presence_of :user
  validates_presence_of :title
  after_create :create_notifications
  after_create :create_actionable

  extend FriendlyId
  friendly_id :slug_candidate, use: :slugged
  has_paper_trail
  has_attachments :photos

  def building
    postable
  end

  def commenters
    comments.collect(&:user).uniq
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

  def words(max = nil)
    (max.present?) ? body.split[0..max].join(' ') : body.split
  end

  def word_count
    body.split.count
  end

  private

  def create_notifications
    postable(includes: :user).users.each { |member| Notification.create(notifiable: self, user: member)  }
  end

  def create_actionable
    Activity.create(actionable: self, user: user, building: postable)
  end
end
