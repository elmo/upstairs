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

  def to_param
    slug
  end

  def mark_as_read!
    update_attributes(read: true)
  end

  def mark_as_unread!
    update_attributes(read: false)
  end

  private

  def set_slug
    self.slug = Digest::MD5.hexdigest("-#{id}-")[0..9] if slug.blank?
  end

  def create_notifications
    notifications.create(notifiable: self, user: recipient)
  end
end
