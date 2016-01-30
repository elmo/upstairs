class Message < ActiveRecord::Base
  belongs_to :sender, foreign_key: :sender_id, class_name: 'User'
  belongs_to :recipient, foreign_key: :recipient_id, class_name: 'User'
  belongs_to :building
  validates_presence_of :sender
  validates_presence_of :recipient
  validates_presence_of :building
  validates_presence_of :body, message: 'Your message is empty.'
  has_many :notifications, as: :notifiable, dependent: :destroy
  before_save :set_slug
  after_create :create_notifications

  scope :to_user, -> (user) {where(recipient_id: user.id ) }
  scope :from_user, -> (user) {where(sender_id: user.id ) }
  scope :is_read, -> { where(is_read: true) }
  scope :is_unread, -> { where(is_read: false ) }

  MESSAGE_UNREAD = 'unread'
  MESSAGE_FROM = 'from'
  MESSAGE_TO = 'to'

  def to_param
    slug
  end

  def mark_as_read!
    self.update_attributes(is_read: true)
  end

  def mark_as_unread!
    self.update_attributes(is_read: false)
  end

  def self.received_messages_count(user, read: false)
    Message.to_user(user).where(recipient_id: user, is_read: read).count
  end

  private

  def set_slug
    self.slug = Digest::MD5.hexdigest("-#{id}-")[0..9] if slug.blank?
  end

  def create_notifications
    notifications.create(notifiable: self, user: recipient)
  end
end
