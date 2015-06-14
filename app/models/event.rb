class Event < ActiveRecord::Base
  extend SimpleCalendar
  has_calendar  attribute: :starts
  belongs_to :building
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  validates_presence_of :starts
  validates_presence_of :title
  validates_presence_of :body

  has_attachments :photos, dependent: :destroy

  def owned_by?(user)
    user_id == user.id
  end

  def postable
    building
  end

end
