class Unit < ActiveRecord::Base
  belongs_to :building
  validates_presence_of :building_id
  validates_presence_of :name
  validates_uniqueness_of :name, scope: :building_id
end
