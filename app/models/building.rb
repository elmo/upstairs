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
  has_many :messages, dependent: :destroy
  has_many :units, dependent: :destroy
  has_many :tenancies, through: :units
  has_many :users, -> {distinct},  through: :memberships, class_name: 'User', foreign_key: 'user_id'

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
    memberships.where(user_id: user.id).last
  end

  def is_member?(user)
    memberships.where(user_id: user.id).exists?
  end

  def grant_guestship(user)
    memberships.find_or_create_by(user: user, membership_type: Membership::MEMBERSHIP_TYPE_GUEST)
  end

  def is_guest?(user)
    users.joins(:memberships)
      .where(memberships: {
               membership_type: Membership::MEMBERSHIP_TYPE_GUEST,
               user_id: user.id }).exists?
  end

  def revoke_guestship(user)
    memberships.where(user: user, membership_type: Membership::MEMBERSHIP_TYPE_GUEST).destroy_all
  end

  def grant_tenantship(user)
    memberships.find_or_create_by(user: user, membership_type: Membership::MEMBERSHIP_TYPE_TENANT)
  end

  def revoke_tenantship(user)
    memberships.where(user: user, membership_type: Membership::MEMBERSHIP_TYPE_TENANT).destroy_all
  end

  def has_tenant?(user)
    users.joins(:memberships)
      .where(memberships: {
               membership_type: Membership::MEMBERSHIP_TYPE_TENANT,
               user_id: user.id }).exists?
  end

  def grant_landlordship(user)
    memberships.find_or_create_by(user: user, membership_type: Membership::MEMBERSHIP_TYPE_LANDLORD)
  end

  def revoke_landlordship(user)
    memberships.where(user: user, membership_type: Membership::MEMBERSHIP_TYPE_LANDLORD).destroy_all
  end

  def landlord
    memberships.landlord.collect(&:user).first
  end

  def is_landlord?(user)
    users.joins(:memberships)
      .where(memberships: {
               membership_type: Membership::MEMBERSHIP_TYPE_LANDLORD,
               user_id: user.id }).exists?
  end

  def managers
    memberships.manager.collect(&:user)
  end

  def tenants
    memberships.tenant.collect(&:user)
  end

  def guests
    memberships.guest.collect(&:user)
  end

  def grant_managership(user)
    memberships.find_or_create_by(user: user, membership_type: Membership::MEMBERSHIP_TYPE_MANAGER)
  end

  def revoke_managership(user)
    memberships.where(user: user, membership_type: Membership::MEMBERSHIP_TYPE_MANAGER).destroy_all
  end

  def is_manager?(user)
    users.joins(:memberships)
      .where(memberships: {
               membership_type: Membership::MEMBERSHIP_TYPE_MANAGER,
               user_id: user.id }).exists?
  end

  def promote_to_tenant(user)
    memberships.where(user_id: user.id, membership_type: Membership::MEMBERSHIP_TYPE_GUEST)
      .update_all(membership_type: Membership::MEMBERSHIP_TYPE_TENANT)
  end

  def public_name
    address
  end

  def short_name
    address.split(',').first
  end


  def alerts_for_user(user)
    alerts.recent.joins(:notifications)
      .where(["notifications.notifiable_id = alerts.id and notifications.notifiable_type = 'Alert' and notifications.user_id = ? ", user.id])
  end

  def alert_notification_for_user(user: user, alert: alert)
    notifications.find_by(user: user.id, notifiable_id: alert.id)
  end

  def owner_verified?
    verifications.exists?
  end

  def occupied_percentage
    units_count = units.count
    return 0 if units_count == 0
    Float(units.occupied.count) / Float(units_count) * 100
  end

  def vacant_percentage
    units_count = units.count
    return 0 if units_count == 0
    Float(units.vacant.count) / Float(units_count) * 100
  end

  private

  def set_invitation_link
    self.invitation_link = SecureRandom.hex(4) if invitation_link.blank?
  end
end
