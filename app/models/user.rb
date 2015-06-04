class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :memberships, dependent: :destroy
  has_many :communities, through: :memberships
  has_many :activities, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :invitations, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :replies, dependent: :destroy
  belongs_to :invitation
  after_create :apply_invitation
  before_save :set_slug

  rolify
  has_paper_trail
  has_attachment :avatar, accept: [:jpg, :png, :gif]

  def join(community)
    self.memberships.create(community_id: community.id) unless member_of?(community)
  end

  def leave(community)
    memberships.where(community_id: community.id).destroy_all
  end

  def member_of?(community)
    memberships.where(community_id: community.id).exists?
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

  def manager_of?(community)
    has_role?(:landlord, community) or has_role?(:manager, community)
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

  def default_community
    (communities.any?) ? communities.first : nil
  end

  def apply_invitation
    if invitation.present?
      community = invitation.community
      join(invitation.community)
      if invitation.type == 'LandlordInvitation'
        self.add_role(:landlord, community) if invitation.type == 'LandlordInvitation'
        community.landlord = self
      end
      self.add_role(:manager, community)  if invitation.type == 'ManagerInvitation'
      community = invitation.community
      community.save
      self.save
    end
  end

  def landlord_or_manager?
    landlord? or manager?
  end

  def landlord?
    roles.where(name: 'Landlord').exists?
  end

  def manager?
     roles.where(name: 'Manager').exists?
  end

  def owned_properties
    roles.where(resource_type: 'Community', name: 'Landlord').collect(&:resource).uniq
  end

  def managed_properties
    roles.where(resource_type: 'Community', name: 'Manager').collect(&:resource).uniq
  end


  private

  def set_slug
    self.slug = SecureRandom.hex(16) if self.slug.blank?
  end

end
