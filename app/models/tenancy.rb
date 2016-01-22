class Tenancy < ActiveRecord::Base
  belongs_to :unit
  belongs_to :user
  belongs_to :building
  validates_presence_of :unit
  validates_presence_of :user
  validates_presence_of :building
  after_create :update_membership
  after_destroy :void_unit

  private

  def update_membership
    existing_guest_membership = user.memberships.find_by(building_id: building.id, membership_type: Membership::MEMBERSHIP_TYPE_GUEST)
    (existing_guest_membership.present?) ? existing_guest_membership.promote_to_tenant_of!(building: building) : user.memberships.find_or_create_by!(building_id: building.id, membership_type: Membership::MEMBERSHIP_TYPE_TENANT)
    unit.update_attributes(user_id: user_id)
  end

  def void_unit
    unit.update_attributes(user_id: nil)
  end
end
