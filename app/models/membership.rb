class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :building
  validates_presence_of :user
  validates_presence_of :building
  validates_uniqueness_of :building, scope: :user
  has_paper_trail
end
