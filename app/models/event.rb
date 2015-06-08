class Event < ActiveRecord::Base
  extend SimpleCalendar
  has_calendar  attribute: :starts
  belongs_to :community
  belongs_to :user
  validates_presence_of :starts
  validates_presence_of :title
  validates_presence_of :body

  def owned_by?(user)
    user_id == user.id
  end

end
