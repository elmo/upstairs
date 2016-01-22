class Unit < ActiveRecord::Base
  belongs_to :building
  has_one :tenancy
  validates_presence_of :building_id
  validates_presence_of :name
  validates_uniqueness_of :name, scope: :building_id

  scope :occupied, -> { joins(:tenancy) }
  scope :vacant, -> { where(user_id: nil) }

  STATUS_OCCUPIED = 'occupied'
  STATUS_VACANT = 'vacant'

  def create_tenancy_for(user:)
     if self.tenancy.present?
       return true if self.tenancy.user.id == user.id
       self.tenancy.destroy
     end
     Tenancy.create(unit_id: self.id, user_id: user.id, building_id: building.id)
  end


end
