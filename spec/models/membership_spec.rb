require 'rails_helper'

RSpec.describe Membership, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:building) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:building) }
  it { should validate_presence_of(:membership_type) }


  describe "constants" do
   it "membership_types" do
     expect(Membership::MEMBERSHIP_TYPE_GUEST).to eq 'Guest'
     expect(Membership::MEMBERSHIP_TYPE_TENANT).to eq 'Tenant'
     expect(Membership::MEMBERSHIP_TYPE_LANDLORD).to eq 'Landlord'
     expect(Membership::MEMBERSHIP_TYPE_MANAGER).to eq 'Manager'
    end
  end

  describe "membership_types" do
    it "are only 'Guest', 'Tenant', 'Landlord', 'Manager' " do
      expect(Membership.membership_types).to eq  ["Guest", "Tenant", "Landlord", "Manager"]
    end
  end

  describe 'creation' do
    before(:each) do
      load_valid_building
      load_user
    end

    it 'creates membership' do
      expect { Membership.create(user: @user, building: @building) }.to change(Membership, :count).by(1)
    end

    it 'does not allow duplicates' do
      Membership.create(user: @user, building: @building)
      expect { Membership.create(user: @user, building: @building) }.to change(Membership, :count).by(0)
    end

    it 'does not creates membership without a user' do
      expect { Membership.create(building: @building) }.to change(Membership, :count).by(0)
    end

    it 'does not creates membership without a building' do
      expect { Membership.create(user: @user) }.to change(Membership, :count).by(0)
    end

    it 'associates user with building' do
      Membership.create(user: @user, building: @building)
      expect(@user.buildings.count).to eq 1
      expect(@user.buildings.first).to eq @building
    end

    it 'associates building with user' do
      Membership.create(user: @user, building: @building)
      expect(@building.users.count).to eq 1
      expect(@building.users.first).to eq @user
    end
  end

  describe "promote_to_tenant_of!" do
    before(:each) do
      load_valid_building
      load_user
      @membership = Membership.create(user: @user, building: @building, membership_type: Membership::MEMBERSHIP_TYPE_GUEST)
    end

    it "updates membership_type" do
      expect { @membership.promote_to_tenant_of!(building: @building) }.to change(@membership, :membership_type).from(Membership::MEMBERSHIP_TYPE_GUEST).to(Membership::MEMBERSHIP_TYPE_TENANT)
    end

  end

end
