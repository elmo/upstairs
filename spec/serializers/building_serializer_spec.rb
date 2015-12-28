require 'rails_helper'
RSpec.describe BuildingSerializer, type: :serializer do
  describe 'attributes' do

    before(:each) do
      load_valid_building
      @building_serializer = BuildingSerializer.new(@building)
      @building.invitation_link = '1ae32608'
    end

    it "id" do
      expect(@building_serializer.id).to eq @building.id
    end

    it "name" do
      expect(@building_serializer.name).to eq @building.name
      expect(@building_serializer.name).to eq 'The Pink Building'
    end

    it "address" do
      expect(@building_serializer.address).to eq @building.address
      expect(@building_serializer.address).to eq "123 Main Street, San Francisco, CA 94121"
    end

    it "invitation_link" do
      expect(@building_serializer.invitation_link).to eq @building.invitation_link
      expect(@building_serializer.invitation_link).to eq "1ae32608"
    end

    it "latitude" do
      expect(@building_serializer.latitude).to eq @building.latitude
      expect(@building_serializer.latitude).to eq 37.780944
    end

    it "longitude" do
      expect(@building_serializer.longitude).to eq @building.longitude
      expect(@building_serializer.longitude).to eq -122.504476
    end

    it "active" do
      expect(@building_serializer.active).to eq @building.active
      expect(@building_serializer.active).to eq true
    end

    it "slug" do
      expect(@building_serializer.slug).to eq @building.slug
      expect(@building_serializer.slug).to eq "123-main-street-san-francisco-ca-94121"
    end

    it "created_at" do
      expect(@building_serializer.created_at).to eq @building.created_at
      expect(@building_serializer.created_at).to eq 'Thu, 01 Jan 2015 00:00:00 UTC +00:00'
    end

    it "updated_at" do
      expect(@building_serializer.updated_at).to eq @building.updated_at
      expect(@building_serializer.created_at).to eq 'Thu, 01 Jan 2015 00:00:00 UTC +00:00'
    end

  end
end
