class Alert < ActiveRecord::Base
  belongs_to :user
  belongs_to :building
  belongs_to :actionable, polymorphic: true
  has_many :notifications, as: :notifiable, dependent: :destroy
  validates_presence_of :user
  validates_presence_of :building

  after_create :create_notifications
  after_create :create_actionable

  scope :recent, -> { where( ["alerts.created_at > ? ", Time.zone.now - 12.hours ] ) }
  scope :for_user , -> (user) { joins(:notifications).
	  where(["notifications.user_id = ? and notifications.notifiable_type = 'Alert'" , user.id ] ) }

  private

  def create_actionable
   Activity.create(actionable: self, user: self.user, building: self.building)
  end

  def create_notifications
    building.users.each { |user| Notification.create(notifiable: self, user: user) }
  end

end
