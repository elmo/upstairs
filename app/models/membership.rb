class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :building
  validates_presence_of :user_id
  validates_presence_of :building_id
  has_paper_trail
end
