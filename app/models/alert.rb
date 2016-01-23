class Alert < ActiveRecord::Base
  belongs_to :user
  belongs_to :building
  belongs_to :actionable, polymorphic: true
  has_many :notifications, as: :notifiable, dependent: :destroy
  validates_presence_of :user
  validates_presence_of :building
  validates_presence_of :message
  validates_length_of :message, maximum: 160, message: "Message is too long"

  after_create :create_notifications
  after_create :create_actionable

  scope :recent, -> { where(['alerts.created_at > ? ', Time.zone.now - 12.hours]) }
  scope :for_user, lambda  { |user|
    joins(:notifications)
      .where(["notifications.user_id = ? and notifications.notifiable_type = 'Alert'", user.id])
  }

  def owned_by?(u)
    user.id == u.id
  end

  private

  def create_actionable
    Activity.create(actionable: self, user: user, building: building)
  end

  def create_notifications
    building.users.each { |user| Notification.create(notifiable: self, user: user) }
  end
end
