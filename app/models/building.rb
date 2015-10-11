class Building < ActiveRecord::Base
  has_many :activities, dependent: :destroy
  has_many :alerts, dependent: :destroy
  has_many :comments, through: :posts, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :invitations, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :notifications, through: :users, dependent: :destroy
  has_many :posts, as: :postable, dependent: :destroy
  has_many :tickets, dependent: :destroy
  has_many :users, through: :memberships
  has_many :verifications, dependent: :destroy
  has_many :verification_requests, dependent: :destroy
  belongs_to :landlord, class_name: 'User', foreign_key: 'landlord_id'
  belongs_to :actionable, polymorphic: true
  validates_presence_of :address
  validates_uniqueness_of :address
  validates_presence_of :latitude
  validates_presence_of :longitude
  before_save :set_invitation_link
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
  scope :verified, -> { joins(:verifications) }

  def membership(user)
    user.memberships.where(user_id: user.id).first
  end

  def public_name
    address
  end

  def alerts_for_user(user)
    alerts.recent.joins(:notifications)
      .where(["notifications.notifiable_id = alerts.id and notifications.notifiable_type = 'Alert' and notifications.user_id = ? ", user.id])
  end

  def landlord
    Role.where(resource_type: 'Building', resource_id: id,  name: User::ROLE_LANDLORD).try(:first).try(:users).try(:first)
  end

  def owner_verified?
    verifications.exists?
  end

  private

  def set_invitation_link
    self.invitation_link = SecureRandom.hex(4) if invitation_link.blank?
  end
end
