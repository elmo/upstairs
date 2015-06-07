class Event < ActiveRecord::Base
  extend SimpleCalendar
  has_calendar  attribute: :starts
  belongs_to :community
  belongs_to :user

  def owned_by?(user)
    user_id == user.id
  end

end
