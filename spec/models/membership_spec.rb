require 'rails_helper'

RSpec.describe Membership, :type => :model do
 it { should belong_to(:user) }
 it { should belong_to(:building) }
 it { should validate_presence_of(:user) }
 it { should validate_presence_of(:building) }

 describe "creation" do

   before(:each) do
     load_valid_building
     load_user
   end

   it "creates membership" do
     expect { Membership.create(user: @user, building: @building) }.to change(Membership, :count).by(1)
   end

   it "does not allow duplicates" do
     Membership.create(user: @user, building: @building)
     expect { Membership.create(user: @user, building: @building) }.to change(Membership, :count).by(0)
   end

   it "does not creates membership without a user" do
     expect { Membership.create(building: @building) }.to change(Membership, :count).by(0)
   end

    it "does not creates membership without a building" do
      expect { Membership.create(user: @user) }.to change(Membership, :count).by(0)
    end

    it "associates user with building" do
      Membership.create(user: @user, building: @building)
      expect(@user.buildings.count).to eq 1
      expect(@user.buildings.first).to eq @building
    end

    it "associates building with user" do
      Membership.create(user: @user, building: @building)
      expect(@building.users.count).to eq 1
      expect(@building.users.first).to eq @user
    end

  end

end
