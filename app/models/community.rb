class Community < ActiveRecord::Base
  has_many :memberships
  has_many :users, through: :memberships
  has_many :posts, as: :postable
  has_many :comments, through: :posts
  has_many :activities
  has_many :alerts
  has_many :tickets
  has_many :notifications, through: :users
  has_many :invitations
  belongs_to :landlord, class_name: 'User', foreign_key: 'landlord_id'
  belongs_to :actionable, polymorphic: true
  validates_presence_of :address
  validates_uniqueness_of :address
  validates_presence_of :latitude
  validates_presence_of :longitude

  resourcify

  geocoded_by :address
  reverse_geocoded_by :latitude, :longitude
  before_validation :geocode
  before_validation :reverse_geocode

  HOMEPAGE_WORD_MAX = 80

  extend FriendlyId
  friendly_id :address, use: :slugged
  has_paper_trail

  has_attachments :photos


  def membership(user)
    user.memberships.where(user_id: user.id).first
  end

  def public_name
    address
  end

  def alerts_for_user(user)
    alerts.recent.joins(:notifications)
     .where(["notifications.notifiable_id = alerts.id and notifications.notifiable_type = 'Alert' and notifications.user_id = ? ", user.id] )
  end

end
