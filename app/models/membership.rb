class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :building
  validates_presence_of :user
  validates_presence_of :building
  validates_presence_of :membership_type
  validates_uniqueness_of :building, scope: [:user, :membership_type]
  has_paper_trail

  MEMBERSHIP_TYPE_GUEST = 'Guest'
  MEMBERSHIP_TYPE_TENANT = 'Tenant'
  MEMBERSHIP_TYPE_LANDLORD = 'Landlord'
  MEMBERSHIP_TYPE_MANAGER = 'Manager'
  MEMBERSHIP_TYPE_VENDOR = 'Vendor'

  scope :guest, -> { where(membership_type:  MEMBERSHIP_TYPE_GUEST) }
  scope :tenant, -> { where(membership_type: MEMBERSHIP_TYPE_TENANT) }
  scope :landlord, -> { where(membership_type: MEMBERSHIP_TYPE_LANDLORD) }
  scope :manager, -> { where(membership_type: MEMBERSHIP_TYPE_MANAGER) }
  scope :rentable, -> { where(['membership_type in (?) ', [MEMBERSHIP_TYPE_GUEST, MEMBERSHIP_TYPE_TENANT]]) }

  def self.membership_types
    [MEMBERSHIP_TYPE_GUEST, MEMBERSHIP_TYPE_TENANT, MEMBERSHIP_TYPE_LANDLORD, MEMBERSHIP_TYPE_MANAGER,MEMBERSHIP_TYPE_VENDOR]
  end

  def promote_to_tenant_of!(building:)
    update_attributes(membership_type: MEMBERSHIP_TYPE_TENANT, building_id: building.id)
  end

  def landlord?
    membership_type == MEMBERSHIP_TYPE_LANDLORD
  end

  def manager?
    membership_type == MEMBERSHIP_TYPE_MANAGER
  end

  def tenant?
    membership_type == MEMBERSHIP_TYPE_TENANT
  end

  def guest?
    membership_type == MEMBERSHIP_TYPE_GUEST
  end

  def vendor?
    membership_type == MEMBERSHIP_TYPE_VENDOR
  end

  def self.allowed_send_invitation_type?(roles, invitation_type)
    allowed_roles = {
      MEMBERSHIP_TYPE_GUEST    => [ MEMBERSHIP_TYPE_GUEST],
      MEMBERSHIP_TYPE_TENANT   => [ MEMBERSHIP_TYPE_GUEST, MEMBERSHIP_TYPE_TENANT],
      MEMBERSHIP_TYPE_VENDOR   => [ MEMBERSHIP_TYPE_GUEST],
      MEMBERSHIP_TYPE_MANAGER  => [ MEMBERSHIP_TYPE_GUEST, MEMBERSHIP_TYPE_TENANT, MEMBERSHIP_TYPE_VENDOR, MEMBERSHIP_TYPE_MANAGER],
      MEMBERSHIP_TYPE_LANDLORD => [ MEMBERSHIP_TYPE_GUEST, MEMBERSHIP_TYPE_TENANT, MEMBERSHIP_TYPE_VENDOR, MEMBERSHIP_TYPE_MANAGER]
    }[invitation_type]
    (roles & allowed_roles).any?
  end

end
