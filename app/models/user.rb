class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :memberships, dependent: :destroy
  has_many :buildings, through: :memberships
  has_many :activities, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :invitations, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :replies, dependent: :destroy
  has_many :events, dependent: :destroy
  belongs_to :invitation
  after_create :apply_invitation
  before_save :set_slug

  rolify
  has_paper_trail
  has_attachment :avatar, accept: [:jpg, :png, :gif]

  def join(building)
    self.memberships.create(building_id: building.id) unless member_of?(building)
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
    phone.present? && phone.length >=10 and phone.length <= 12
  end

  def admin?
    has_role?(:admin)
  end

  def owns?(obj)
    id == obj.user_id
  end

  def public_name
    use_my_username? && username.present? ? username : 'anonymous'
  end

  def manager_of?(building)
    has_role?(:landlord, building) or has_role?(:manager, building)
  end

  def created?(object)
    id == object.user_id
  end

  def sent_messages
    Message.where(sender_id: self.id)
  end

  def received_messages
    Message.where(recipient_id: self.id)
  end

  def received_messages_count
    Message.where(recipient_id: self.id).count
  end

  def sent_messages_count
    Message.where(sender_id: self.id).count
  end

  def default_building
    (buildings.any?) ? buildings.first : nil
  end

  def apply_invitation
    if invitation.present?
      building = invitation.building
      join(invitation.building)
      if invitation.type == 'LandlordInvitation'
        self.add_role(:landlord, building) if invitation.type == 'LandlordInvitation'
        building.landlord = self
      end
      self.add_role(:manager, building)  if invitation.type == 'ManagerInvitation'
      building = invitation.building
      building.save
      self.save
    end
  end

  def landlord_or_manager?
    landlord? or manager?
  end

  def landlord?
    properties.any?
  end

  def manager?
     roles.where(name: 'Manager').exists?
  end

  def owned_properties
    roles.where(resource_type: 'Building', name: 'Landlord').collect(&:resource).uniq
  end

  def managed_properties
    roles.where(resource_type: 'Building', name: 'Manager').collect(&:resource).uniq
  end

  def to_param
    slug
  end

  def owner_or_manager_of?(building)
    building.landlord_id == self.id
  end

  def properties
    Building.where(landlord_id: self.id)
  end

  private

  def set_slug
    self.slug = SecureRandom.hex(16) if self.slug.blank?
  end

end
