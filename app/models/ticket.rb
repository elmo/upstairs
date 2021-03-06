class Ticket < ActiveRecord::Base
  belongs_to :user
  belongs_to :building
  belongs_to :actionable, polymorphic: true
  has_one :assignment
  has_many :notifications, as: :notifiable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  validates_presence_of :user
  validates_presence_of :title, message: 'Please enter a title for your maintenance issue.'
  validates_presence_of :severity
  validates_presence_of :status
  validates_presence_of :body, message: 'Please enter the details of your maintenance issue.'
  after_create :create_notifications
  after_create :create_actionable

  STATUS_NEW = 'New'
  STATUS_OPEN = 'Open'
  STATUS_CLOSED = 'Closed'
  SEVERITY_MINOR = 'Minor'
  SEVERITY_SERIOUS = 'Serious'
  SEVERITY_SEVERE = 'Severe'

  scope :open, -> { where(status: STATUS_OPEN) }
  scope :closed, -> { where(status: STATUS_CLOSED) }
  scope :minor, -> { where(severity: SEVERITY_MINOR) }
  scope :serious, -> { where(severity: SEVERITY_SERIOUS) }
  scope :severe, -> { where(severity: SEVERITY_SEVERE) }

  scope :managed_by, lambda  { |user|
    where(building_id: user.owned_and_managed_properties.collect(&:id) )
  }

  #extend FriendlyId

  resourcify
  has_attachments :photos, dependent: :destroy

  def postable
    building
  end

  def owned_by?(user)
    user_id == user.id
  end

  def owned_or_manged_by?(user)
    owned_by?(user) or user.owned_and_managed_properties.collect(&:id).include?(building.id)
  end

  def self.statuses
    [STATUS_OPEN, STATUS_CLOSED]
  end

  def self.severities
    [SEVERITY_MINOR, SEVERITY_SERIOUS, SEVERITY_SEVERE]
  end

  def open?
    status == STATUS_OPEN
  end

  def closed?
    status == STATUS_CLOSED
  end

  def escalateable?
    Ticket.escalateable_severities.include?(severity)
  end

  def deescalateable?
    Ticket.deescalateable_severities.include?(severity)
  end

  def self.escalateable_severities
    [SEVERITY_MINOR, SEVERITY_SERIOUS]
  end

  def self.deescalateable_severities
    [SEVERITY_SERIOUS, SEVERITY_SEVERE]
  end

  def open!
    update_attributes(status: STATUS_OPEN)
  end

  def close!
    update_attributes(status: STATUS_CLOSED)
  end

  def escalate!
    update_attributes(severity: SEVERITY_SEVERE) if severity == SEVERITY_SERIOUS
    update_attributes(severity: SEVERITY_SERIOUS) if severity == SEVERITY_MINOR
  end

  def deescalate!
    update_attributes(severity: SEVERITY_MINOR) if severity == SEVERITY_SERIOUS
    update_attributes(severity: SEVERITY_SERIOUS) if severity == SEVERITY_SEVERE
  end

  def candidate_assignees
    User.managers_and_vendors_for(building.landlord)
  end

  def generic_name
    "#{self.class.to_s}: ##{id}"
  end

  def notifiable_users(except_user: nil)
   user_ids = self.comments.collect(&:user_id).uniq
   user_ids.delete(except_user.id) if except_user.present?
   return [] if user_ids.empty?
   User.where(id: user_ids )
  end

  private

  def create_notifications
    building(includes: :user).users.each { |member| Notification.create(notifiable: self, user: member)  }
  end

  def create_actionable
    Activity.create(actionable: self, user: user, building: building)
  end
end
