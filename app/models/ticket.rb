class Ticket < ActiveRecord::Base
  belongs_to :user
  belongs_to :community
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

  has_attachments :photos, dependent: :destroy

  private

  def create_notifications
    community(includes: :user).users.each { |member| Notification.create(notifiable: self, user: member)  }
  end

  def create_actionable
    Activity.create(actionable: self, user: self.user, community: self.community)
  end


end
