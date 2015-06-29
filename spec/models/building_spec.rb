require 'rails_helper'

RSpec.describe Building, :type => :model do
    it { should have_many(:activities) }
    it { should have_many(:alerts) }
    it { should have_many(:comments) }
    it { should have_many(:events) }
    it { should have_many(:invitations) }
    it { should have_many(:memberships) }
    it { should have_many(:notifications) }
    it { should have_many(:posts) }
    it { should have_many(:users) }
    it { should have_many(:tickets) }
    it { should belong_to(:landlord) }
    it { should validate_presence_of(:address) }
    it { should validate_presence_of(:latitude) }
    it { should validate_presence_of(:longitude) }


    describe "a building" do
       before(:each) do
	 @address = "123 Main Street, San Francisco, CA 94121"
         @building = Building.new(address: @address)
         Building.any_instance.stub(:geocode).and_return(true)
         Building.any_instance.stub(:reverse_geocode).and_return(true)
       end

       it "does not save without latitude and longitude" do
	 expect(@building.save).to be false
	 expect(@building.errors.messages).to eq({:latitude=>["can't be blank"], :longitude=>["can't be blank"]})
       end

       it "saves with latitude and longitude" do
         @building.latitude = 37.780944
         @building.longitude = -122.504476
	 expect{@building.save}.to change(Building, :count).by(1)
       end

       it "geocodes" do
         @building.latitude = 37.780944
         @building.longitude = -122.504476
	 expect(@building).to receive(:geocode).exactly(1).times
	 @building.save
       end

       it "reverse geocodes" do
         @building.latitude = 37.780944
         @building.longitude = -122.504476
	 expect(@building).to receive(:reverse_geocode).exactly(1).times
	 @building.save
       end

       it "HOMEPAGE_WORD_MAX" do
         expect(Building::HOMEPAGE_WORD_MAX).to eq 80
       end
    end

    describe "with all required attributes" do
      before(:each) do
         load_valid_building
      end

      it "has an address" do
         expect(@building.address).to eq @address
      end

      it "has an latitude" do
        expect(@building.latitude).to eq 37.780944
      end

      it "has an longitude" do
        expect(@building.longitude).to eq -122.504476
      end

      it "has a public_name to eq address" do
         expect(@building.public_name).to eq @address
      end

      it "set_invitation_link" do
         expect(@building.invitation_link).to eq "d70031c6"
      end

      it "has a slugifed address parameter" do
         expect(@building.to_param).to eq "123-main-street-san-francisco-ca-94121"
      end

      it "alerts for user" do
        @user = create(:user, email: "user@email.com")
	@alert = create(:alert, user: @user, building: @building, message: "message")
	Notification.any_instance.stub(:deliver_later).and_return(true)
	Notification.create(notifiable: @alert, user: @user)
	expect(@building.alerts_for_user(@user).first).to eq @alert
      end

      describe "memberships" do
         before(:each) do
           @user = create(:user, email: "user@email.com")
           @user.join(@building)
         end

	 it "memberships" do
           expect(@building.memberships.count).to eq 1
         end

	 it "membership" do
           expect(@building.membership(@user)).to be_present
         end

	 it "users" do
           expect(@building.users.count).to eq 1
         end
      end
    end
end
