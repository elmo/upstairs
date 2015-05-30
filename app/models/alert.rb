class Alert < ActiveRecord::Base
  belongs_to :user
  belongs_to :community
  belongs_to :actionable, polymorphic: true
  has_many :notifications, as: :notifiable, dependent: :destroy

  after_create :create_notifications
  after_create :create_actionable

  scope :recent, -> { where( ["alerts.created_at > ? ", Time.zone.now - 12.hours ] ) }
  scope :for_user , -> (user) { joins(:notifications).
	  where(["notifications.user_id = ? and notifications.notifiable_type = 'Alert'" , user.id ] ) }

  private

  def create_actionable
   Activity.create(actionable: self, user: self.user, community: self.community)
  end

  def create_notifications
    community.users.each { |user| Notification.create(notifiable: self, user: user) }
  end

end
