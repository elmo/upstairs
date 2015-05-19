class AddLandlordIdToCommunity < ActiveRecord::Migration
  def change
    add_column :communities, :landlord_id, :integer
  end
end
