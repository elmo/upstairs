class Message < ActiveRecord::Base
  belongs_to :messageable, polymorphic: true
  belongs_to :sender, foreign_key: :sender_id, class_name: 'User'
  belongs_to :recipient, foreign_key: :recipient_id, class_name: 'User'
  belongs_to :community
  validates_presence_of :sender
  validates_presence_of :recipient
  validates_presence_of :community
  validates_presence_of :body, message: "Your message is empty."
  has_many :notifications, as: :notifiable
  after_create :create_notifications

  private

  def create_notifications
    self.notifications.create(notifiable: self, user: recipient)
  end

end
