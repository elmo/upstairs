def load_valid_building
  Timecop.freeze(2015, 1, 1) do
    Building.any_instance.stub(:geocode).and_return(true)
    Building.any_instance.stub(:reverse_geocode).and_return(true)
    @address = '123 Main Street, San Francisco, CA 94121'
    @building = Building.new(address: @address)
    @building.latitude = 37.780944
    @building.longitude = -122.504476
    @building.name = 'The Pink Building'
    @building.save
  end
end

def load_unverified_builiding
  load_valid_building
end

def load_valid_building_with_unit
  load_valid_building
  @unit = create(:unit, building: @building)
end

def load_verified_building
  @landlord = create(:landlord)
  @landlord.make_landlord(@building)
  @verifier = create(:verification, user: @landlord, building: @building, verifier: create(:verifier))
end
