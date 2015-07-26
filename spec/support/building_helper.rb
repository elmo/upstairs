def load_valid_building
  Building.any_instance.stub(:geocode).and_return(true)
  Building.any_instance.stub(:reverse_geocode).and_return(true)
  @address = "123 Main Street, San Francisco, CA 94121"
  @building = Building.new(address: @address)
  @building.latitude = 37.780944
  @building.longitude = -122.504476
  @building.save
end

