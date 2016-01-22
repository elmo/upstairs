class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook, :google]

  has_many :activities, dependent: :destroy
  has_many :buildings, through: :memberships
  has_many :comments, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :invitations, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :replies, dependent: :destroy
  has_many :verifications, dependent: :destroy
  belongs_to :invitation
  belongs_to :tenancy
  belongs_to :sender, foreign_key: 'sender_id', class_name: 'User'
  after_create :apply_invitation
  before_save :set_slug

  rolify

  ROLE_LANDLORD = 'Landlord'
  ROLE_MANAGER = 'Manager'
  INVITATION_LANDLORD = 'LandlordInvitation'
  INVITATION_MANAGER = 'ManagerInvitation'

  PROFILE_STATUS_NEW = 0
  PROFILE_STATUS_WELCOMED = 5
  PROFILE_STATUS_BUILDING_CHOSEN = 10
  PROFILE_STATUS_BUILDING_OWNERSHIP_DECLARED = 15

  has_paper_trail
  has_attachment :avatar, accept: [:jpg, :png, :gif]

  def join(building)
    building.grant_guestship(self)
    profile_building_chosen!
  end

  def grant(membership, membership_type)
    user = membership.user
    building = membership.building
    fail 'Invalid membership type' unless Membership.membership_types.include?(membership_type)
    case membership_type
      when Membership::MEMBERSHIP_TYPE_LANDLORD
        fail 'Unable to grant permission' unless permitted_to_grant_landlordship?(building)
        user.make_landlord(building)
      when Membership::MEMBERSHIP_TYPE_MANAGER
        fail 'Unable to grant permission' unless permitted_to_grant_managership?(building)
        user.make_manager(building)
      when Membership::MEMBERSHIP_TYPE_TENANT
        fail 'Unable to grant tenant membership' unless permitted_to_grant_tenantship?(building)
        user.make_tenant(building)
      when Membership::MEMBERSHIP_TYPE_GUEST
        user.make_guest(building)
    end
  end

  def revoke(membership, membership_type)
    user = membership.user
    building = membership.building
    fail 'Invalid membership type' unless Membership.membership_types.include?(membership_type)
    case membership_type
      when Membership::MEMBERSHIP_TYPE_LANDLORD
        fail 'Unable to revoke permission' unless permitted_to_revoke_landlordship?(building)
        user.revoke_landlord(building)
      when Membership::MEMBERSHIP_TYPE_MANAGER
        fail 'Unable to revoke permission' unless permitted_to_revoke_managership?(building)
        user.revoke_manager(building)
      when Membership::MEMBERSHIP_TYPE_TENANT
        fail 'Unable to revoke tenant membership' unless permitted_to_revoke_tenantship?(building)
        user.revoke_tenant(building)
      when Membership::MEMBERSHIP_TYPE_GUEST
        user.revoke_guest(building)
    end
  end

  def permitted_to_grant_landlordship?(_building)
    admin?
  end

  def permitted_to_revoke_landlordship?(_building)
    admin?
  end

  def permitted_to_grant_managership?(building)
    admin? || landlord_of?(building)
  end

  def permitted_to_revoke_managership?(building)
    admin? || landlord_of?(building)
  end

  def permitted_to_grant_tenantship?(building)
    admin? || landlord_of?(building)
  end

  def permitted_to_revoke_tenantship?(building)
    admin? || landlord_of?(building)
  end

  def leave(building)
    memberships.where(building_id: building.id).destroy_all
  end

  def member_of?(building)
    memberships.where(building_id: building.id).exists?
  end

  def receives_text_messages?
    ok_to_send_text_messages? && phone_valid?
  end

  def phone_valid?
    phone.present? && phone.length >= 10 && phone.length <= 12
  end

  def admin?
    has_role?(:admin)
  end

  def verifier?
    has_role?(:verifier)
  end

  def make_verifier
    add_role(:verifier)
  end

  def make_admin
    add_role(:admin)
  end

  def owns?(obj)
    id == obj.user_id
  end

  def public_name
    use_my_username? && username.present? ? username : 'anonymous'
  end

  def primary_residence
    (memberships.any?) ? memberships.first.building : nil
  end

  def sent_messages
    Message.where(sender_id: id)
  end

  def received_messages
    Message.where(recipient_id: id)
  end

  def received_messages_count
    Message.where(recipient_id: id).count
  end

  def sent_messages_count
    Message.where(sender_id: id).count
  end

  def has_unread_messages?
    Message.where(recipient_id: id, read: false).any?
  end

  def default_building
    (buildings.any?) ? buildings.first : nil
  end

  def tenant_of?(building)
    memberships.exists?(building_id: building.id, membership_type: Membership::MEMBERSHIP_TYPE_TENANT)
  end

  def make_landlord(building)
    memberships.where(building_id: building.id).destroy_all
    memberships.create!(building_id: building.id, membership_type: Membership::MEMBERSHIP_TYPE_LANDLORD)
  end

  def revoke_landlord(building)
    memberships.where(building_id: building.id, membership_type: Membership::MEMBERSHIP_TYPE_LANDLORD).destroy_all
  end

  def manager_of?(building)
    memberships.exists?(building_id: building.id, membership_type: Membership::MEMBERSHIP_TYPE_MANAGER)
  end

  def landlordships
    memberships.landlord
  end

  def managerships
    memberships.manager
  end

  def landlorship_of(building:)
    memberships.find_by(building_id: building.id, membership_type: Membership::MEMBERSHIP_TYPE_LANDLORD)
  end

  def managership_of(building:)
    memberships.find_by(building_id: building.id, membership_type: Membership::MEMBERSHIP_TYPE_MANAGER)
  end

  def tenantship_of(building:)
    memberships.find_by(building_id: building.id, membership_type: Membership::MEMBERSHIP_TYPE_TENANT)
  end

  def guestship_of(building:)
    memberships.find_by(building_id: building.id, membership_type: Membership::MEMBERSHIP_TYPE_GUEST)
  end

  def membership_of(building:)
    memberships.find_by(building_id: building.id)
  end

  def tenantships
    memberships.tenant
  end

  def guestships
    memberships.guest
  end

  def make_manager(building)
    memberships.find_or_create_by(building_id: building.id, membership_type: Membership::MEMBERSHIP_TYPE_MANAGER)
  end

  def revoke_manager(building)
    memberships.where(building_id: building.id, membership_type: Membership::MEMBERSHIP_TYPE_MANAGER).destroy_all
  end

  def make_tenant(building)
    memberships.find_or_create_by(building_id: building.id, membership_type: Membership::MEMBERSHIP_TYPE_TENANT)
  end

  def revoke_tenant(building)
    memberships.where(building_id: building.id, membership_type: Membership::MEMBERSHIP_TYPE_TENANT).destroy_all
  end

  def make_guest(building)
    memberships.find_or_create_by(building_id: building.id, membership_type: Membership::MEMBERSHIP_TYPE_GUEST)
  end

  def revoke_guest(building)
    memberships.where(building_id: building.id, membership_type: Membership::MEMBERSHIP_TYPE_GUEST).destroy_all
  end

  def change_membership(membership_type: membership_type, building: building)
    memberships.where(building_id: building.id).update_all(membership_type: membership_type) if Membership.membership_types.include?(membership_type)
  end

  def clear_all_memberships(building)
    memberships.where(building_id: building.id).destroy_all
  end

  def apply_invitation
    if invitation.present?
      building = invitation.building
      join(invitation.building)
      make_landlord(building) if invitation.type == INVITATION_LANDLORD
      make_manager(building) if invitation.type == INVITATION_MANAGER
      building = invitation.building
      building.save
      save
    end
  end

  def landlord_or_manager?
    landlord? || manager?
  end

  def landlord?
    landlordships.any?
  end

  def landlord_of?(building)
    memberships.exists?(building_id: building.id, membership_type: Membership::MEMBERSHIP_TYPE_LANDLORD)
  end

  def manager?
    managerships.any?
  end

  def owned_properties
    landlordships.collect(&:building)
  end

  def managed_properties
    managerships.collect(&:building)
  end

  def to_param
    slug
  end

  def verify_ownership(building:, verifier:, verification_request:)
    verifications.create(building: building, verifier: verifier, verification_request: verification_request)
  end

  def verified_owner_of?(building)
    verifications.exists?(building_id: building.id)
  end

  def brand_new?
    profile_status == PROFILE_STATUS_NEW
  end

  def welcomed?
    profile_status >= PROFILE_STATUS_WELCOMED
  end

  def building_chosen?
    profile_status >= PROFILE_STATUS_BUILDING_CHOSEN
  end

  def profile_building_ownership_declared?
    profile_status >= PROFILE_STATUS_BUILDING_OWNERSHIP_DECLARED
  end

  def profile_building_chosen!
    update_attributes(profile_status: PROFILE_STATUS_BUILDING_CHOSEN)
  end

  def profile_welcomed!
    update_attributes(profile_status: PROFILE_STATUS_WELCOMED)
  end

  def profile_building_ownership_declared!
    update_attributes(profile_status: PROFILE_STATUS_BUILDING_OWNERSHIP_DECLARED)
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.username = auth.info.try(:name)
      user.password = Devise.friendly_token[0, 20]
    end
  end

  private

  def set_slug
    while slug.blank?
      s = SecureRandom.hex(5)
      next if User.where(slug: s).exists?
      self.slug = s
    end
  end
end
