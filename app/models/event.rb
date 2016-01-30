class Event < ActiveRecord::Base
  belongs_to :building
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  validates_presence_of :starts
  validates_presence_of :title
  validates_presence_of :body
  after_create :create_notifications
  PAST = 'past'
  FUTURE = 'future'

  #extend FriendlyId
  #friendly_id :slug_candidates, use: :slugged

  scope :managed_by, lambda {|user|
    where(building_id: user.owned_and_managed_properties.collect(&:id) )
  }
  scope :past, -> { where(["starts < ? ", Time.now ]) }
  scope :future, -> { where(["starts > ? ", Time.now ]) }

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

  #def slug_candidates
  #  [:title]
  #end

  private

  def create_notifications
    building(includes: :user).users.each { |user| Notification.create(notifiable: self, user: user) }
  end
end
