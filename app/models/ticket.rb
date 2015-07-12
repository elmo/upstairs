class Ticket < ActiveRecord::Base
  belongs_to :user
  belongs_to :building
  belongs_to :actionable, polymorphic: true
  has_many :notifications, as: :notifiable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  validates_presence_of :user
  validates_presence_of :title, message: "Please enter a title for your maintenance issue."
  validates_presence_of :severity
  validates_presence_of :status
  validates_presence_of :body, message: "Please enter the details of your maintenance issue."
  after_create :create_notifications
  after_create :create_actionable

  scope :open, -> { where(status: STATUS_OPEN )}
  scope :closed, -> { where(status: STATUS_CLOSED)}
  scope :minor, -> { where(severity: SEVERITY_MINOR)}
  scope :serious, -> { where(severity: SEVERITY_SERIOUS)}
  scope :severe, -> { where(severity: SEVERITY_SEVERE)}

  STATUS_OPEN = 'open'
  STATUS_CLOSED = 'closed'
  SEVERITY_MINOR = 'minor'
  SEVERITY_SERIOUS = 'serious'
  SEVERITY_SEVERE = 'severe'

  resourcify
  has_attachments :photos, dependent: :destroy

  def postable
    building
  end

  def owned_by?(user)
    user_id == user.id
  end

  private

  def create_notifications
    building(includes: :user).users.each { |member| Notification.create(notifiable: self, user: member)  }
  end

  def create_actionable
    Activity.create(actionable: self, user: self.user, building: self.building)
  end
end
