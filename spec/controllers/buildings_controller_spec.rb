require 'rails_helper'
RSpec.describe BuildingsController, :type => :controller do
  let(:valid_attributes) {
    {
      address:  "123 Main Street, San Francisco, CA 94121"
    }
  }
  let(:invalid_attributes) { }

  before(:each) do
    Building.any_instance.stub(:geocode).and_return(true)
    Building.any_instance.stub(:reverse_geocode).and_return(true)
    request.env["HTTP_REFERER"] = "http://www.upstairs.io"
    load_user
    sign_in(@user)
  end

  describe "GET show" do
    it "assigns the requested building as @building" do
      load_valid_building
      get :show, :id => @building.slug
      expect(assigns(:building)).to eq(@building)
    end
  end
end
