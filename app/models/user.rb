class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

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
  after_create :apply_invitation
  before_save :set_slug

  rolify

  ROLE_LANDLORD = 'Landlord'
  ROLE_MANAGER = 'Manager'
  INVITATION_LANDLORD = 'LandlordInvitation'
  INVITATION_MANAGER = 'ManagerInvitation'

  has_paper_trail
  has_attachment :avatar, accept: [:jpg, :png, :gif]

  def join(building)
    memberships.create(building_id: building.id) unless member_of?(building)
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

  def owns?(obj)
    id == obj.user_id
  end

  def public_name
    use_my_username? && username.present? ? username : 'anonymous'
  end

  def manager_of?(building)
    has_role?(:landlord, building) || has_role?(:manager, building)
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

  def default_building
    (buildings.any?) ? buildings.first : nil
  end

  def make_landlord(building)
    add_role(ROLE_LANDLORD, building)
  end

  def revoke_landlord(building)
    remove_role(ROLE_LANDLORD, building)
  end

  def make_manager(building)
    add_role(ROLE_MANAGER, building)
  end

  def revoke_manager(building)
    remove_role(ROLE_MANAGER, building)
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
    roles.where(resource_type: 'Building', name: ROLE_LANDLORD).exists?
  end

  def landlord_of?(building)
    roles.where(resource_type: 'Building', name: ROLE_LANDLORD, resource_id: building.id).exists?
  end

  def manager?
    roles.where(name: ROLE_MANAGER).exists?
  end

  def owned_properties
    roles.where(resource_type: 'Building', name: ROLE_LANDLORD).collect(&:resource).uniq
  end

  def managed_properties
    roles.where(resource_type: 'Building', name: ROLE_MANAGER).collect(&:resource).uniq
  end

  def to_param
    slug
  end

  def owner_or_manager_of?(building)
     false
  end

  def verify_ownership(building:, verifier:, verification_request:)
    verifications.create(building: building, verifier: verifier, verification_request: verification_request)
  end

  def verified_owner_of?(building)
    verifications.exists?(building_id: building.id)
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
