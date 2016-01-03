def create_valid_post
  @post = create(:post, postable: @building, user: @user, title: 'title', body: 'body')
end

def create_valid_tip
  category = Category.create(name: 'Tips', color: 'red')
  @post = create(:post, postable: @building, user: @user, title: 'title', body: 'body', category: category)
end

def load_building_with_one_post
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
  @post = create(:post, postable: @building, user: @user, title: 'title', body: 'body')
end
