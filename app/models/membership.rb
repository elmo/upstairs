class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :community
  validates_presence_of :user_id
  validates_presence_of :community_id
  has_paper_trail
end
