require 'rails_helper'

RSpec.describe Membership, :type => :model do
 it { should belong_to(:user) }
 it { should belong_to(:building) }
 it { should validate_presence_of(:user_id) }
 it { should validate_presence_of(:building_id) }

 describe "creation" do

   before(:each) do
     @user = create(:user, email: "#{SecureRandom.hex(6)}-user@email.com")
     @building = create(:building)
   end

   it "creates membership" do
     expect { Membership.create(user: @user, building: @building) }.to change(Membership, :count).by(1)
   end

   it "does not allow duplicates" do
     expect { Membership.create(user: @user, building: @building) }.to change(Membership, :count).by(1)
     expect { Membership.create(user: @user, building: @building) }.to raise_error ActiveRecord::RecordNotUnique
   end

   it "does not creates membership without a user" do
     expect { Membership.create(building: @building) }.to change(Membership, :count).by(0)
   end

    it "does not creates membership without a building" do
      expect { Membership.create(user: @user) }.to change(Membership, :count).by(0)
    end

    it "associates user with building" do
      Membership.create(user: @user, building: @building)
      expect(@user.communities.count).to eq 1
      expect(@user.communities.first).to eq @building
    end

    it "associates building with user" do
      Membership.create(user: @user, building: @building)
      expect(@building.users.count).to eq 1
      expect(@building.users.first).to eq @user
    end

  end

end
