class Tenancy < ActiveRecord::Base
  belongs_to :unit
  belongs_to :user
  belongs_to :building
  validates_presence_of :unit
  validates_presence_of :user
  validates_presence_of :building
end
