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
    if tenancy.present?
      return true if tenancy.user.id == user.id
      tenancy.destroy
    end
    Tenancy.create(unit_id: id, user_id: user.id, building_id: building.id)
  end


  def self.statuses
    [STATUS_OCCUPIED, STATUS_VACANT]
  end

end
