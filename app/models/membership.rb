class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :building
  validates_presence_of :user
  validates_presence_of :building
  validates_presence_of :membership_type
  validates_uniqueness_of :building, scope: :user
  has_paper_trail
  MEMBERSHIP_TYPE_GUEST = 'Guest'
  MEMBERSHIP_TYPE_TENANT = 'Tenant'
  MEMBERSHIP_TYPE_LANDLORD = 'Landlord'
  MEMBERSHIP_TYPE_MANAGER= 'Manager'

  scope :guest, -> { where(membership_type:  MEMBERSHIP_TYPE_GUEST ) }
  scope :tenant, -> { where(membership_type: MEMBERSHIP_TYPE_TENANT ) }
  scope :landlord, -> { where(membership_type: MEMBERSHIP_TYPE_LANDLORD ) }
  scope :manager, -> { where(membership_type: MEMBERSHIP_TYPE_MANAGER) }

  def self.membership_types
   [MEMBERSHIP_TYPE_GUEST, MEMBERSHIP_TYPE_TENANT, MEMBERSHIP_TYPE_LANDLORD, MEMBERSHIP_TYPE_MANAGER]
  end

end
