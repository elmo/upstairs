class Event < ActiveRecord::Base
  belongs_to :building
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  validates_presence_of :starts
  validates_presence_of :title
  validates_presence_of :body
  after_create :create_notifications

  scope :managed_by, lambda {|user|
    where(building_id: user.owned_and_managed_properties.collect(&:id) )
  }

  extend FriendlyId

  has_attachments :photos, dependent: :destroy

  def owned_by?(user)
    user_id == user.id
  end

  def postable
    building
  end

  def commenters
    comments.collect(&:user).uniq
  end

  private

  def create_notifications
    building(includes: :user).users.each { |user| Notification.create(notifiable: self, user: user) }
  end
end
