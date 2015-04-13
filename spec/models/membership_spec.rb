require 'rails_helper'

RSpec.describe Membership, :type => :model do
 it { should belong_to(:user) }
 it { should belong_to(:community) }
 it { should validate_presence_of(:user_id) }
 it { should validate_presence_of(:community_id) }

 describe "creation" do

   before(:each) do
     @user = create(:user, email: "#{SecureRandom.hex(6)}-user@email.com")
     @community = create(:community)
   end

   it "creates membership" do
     expect { Membership.create(user: @user, community: @community) }.to change(Membership, :count).by(1)
   end

   it "does not allow duplicates" do
     expect { Membership.create(user: @user, community: @community) }.to change(Membership, :count).by(1)
     expect { Membership.create(user: @user, community: @community) }.to raise_error ActiveRecord::RecordNotUnique
   end

   it "does not creates membership without a user" do
     expect { Membership.create(community: @community) }.to change(Membership, :count).by(0)
   end

    it "does not creates membership without a community" do
      expect { Membership.create(user: @user) }.to change(Membership, :count).by(0)
    end

    it "associates user with community" do
      Membership.create(user: @user, community: @community)
      expect(@user.communities.count).to eq 1
      expect(@user.communities.first).to eq @community
    end

    it "associates community with user" do
      Membership.create(user: @user, community: @community)
      expect(@community.users.count).to eq 1
      expect(@community.users.first).to eq @user
    end

  end

end
