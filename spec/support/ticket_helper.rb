def create_valid_ticket
  @ticket = create(:ticket, building: @building,
		   user: @user,
		   title: 'title',
		   body: 'body',
		   severity: 'low',
		   status: 'new')
end

def load_building_with_one_ticket
  Timecop.freeze(2015,1,1) do
    Building.any_instance.stub(:geocode).and_return(true)
    Building.any_instance.stub(:reverse_geocode).and_return(true)
    @address = '123 Main Street, San Francisco, CA 94121'
    @building = Building.new(address: @address)
    @building.latitude = 37.780944
    @building.longitude = -122.504476
    @building.name = 'The Pink Building'
    @building.save
  end
  @user = create(:user, email: "#{SecureRandom.hex(6)}-user@email.com")
  @ticket = create(:ticket, building: @building,
		   user: @user,
		   title: 'title',
		   body: 'body',
		   severity: 'low',
		   status: 'new')
end

def valid_ticket_params
  { title: 'title', body: 'body' , status: Ticket::STATUS_OPEN, severity: Ticket::SEVERITY_MINOR}
end
