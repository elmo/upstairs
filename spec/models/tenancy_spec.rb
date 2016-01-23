require 'rails_helper'
RSpec.describe Tenancy, type: :model do
  it { should belong_to(:unit) }
  it { should belong_to(:user) }
  it { should belong_to(:building) }

  before(:each) do
    load_valid_building_with_unit
  end

  it 'has units' do
    expect(@building.units.count).to eq 1
  end

  describe 'tenancy' do
    before(:each) do
      load_user
    end

    it 'creates tenancy' do
      expect { Tenancy.create!(user: @user, unit: @unit, building: @building) }.to change(Tenancy, :count).by(1)
    end

    it 'does not create tenancy without user' do
      expect { Tenancy.create!(unit: @unit, building: @building) }.to raise_error ActiveRecord::RecordInvalid
    end

    it 'does not create tenancy without unit' do
      expect { Tenancy.create!(user: @user, building: @building) }.to raise_error ActiveRecord::RecordInvalid
    end

    it 'does not create tenancy without building' do
      expect { Tenancy.create!(user: @user, unit: @unit) }.to raise_error ActiveRecord::RecordInvalid
    end

    before(:each) do
      @tenancy = create(:tenancy, user: @user, unit: @unit, building: @building)
    end

    it 'is associated with user' do
      expect(@tenancy.user).to eq(@user)
    end

    it 'is associated with unit' do
      expect(@tenancy.unit).to eq(@unit)
    end

    it 'is associated with the building' do
      expect(@tenancy.building).to eq(@building)
    end
  end

  describe 'update_membership' do
    before(:each) do
      load_user
    end

    it 'calls update membership' do
      Tenancy.any_instance.should_receive(:update_membership).exactly(1).times
      Tenancy.create!(user: @user, unit: @unit, building: @building)
    end

    it 'creates a new membership record,if none exists' do
      expect { Tenancy.create!(user: @user, unit: @unit, building: @building) }.to change(Membership, :count).by(1)
      expect(Membership.last.membership_type).to eq Membership::MEMBERSHIP_TYPE_TENANT
    end

    describe 'when a guest membership exits' do
      before(:each) do
        @user.join(@building)
      end

      it 'updates and existing membership' do
        expect(Membership.count).to eq 1
        expect(Membership.first.membership_type).to eq Membership::MEMBERSHIP_TYPE_GUEST
      end

      it 'creating tenancy, changes associated membership' do
        expect(Membership.first.membership_type).to eq Membership::MEMBERSHIP_TYPE_GUEST
        Tenancy.create!(user: @user, unit: @unit, building: @building)
        expect(Membership.last.membership_type).to eq Membership::MEMBERSHIP_TYPE_TENANT
      end

      it "doesn't create an new membership" do
        expect do
          Tenancy.create!(user: @user, unit: @unit, building: @building)
        end.to change(Membership, :count).by(0)
      end

      it 'updates unit user id' do
        Tenancy.create!(user: @user, unit: @unit, building: @building)
        @unit.reload
        expect(@unit.user_id).to eq @user.id
      end
    end
  end

  describe 'void_unit' do
    before(:each) do
      load_user
      @user.join(@building)
      @tenancy = Tenancy.create(user: @user, unit: @unit, building: @building)
    end

    it 'voids unit' do
      expect(@tenancy.unit.user_id).to eq @user.id
      @tenancy.destroy
      expect(@tenancy.unit.user_id).to be_nil
    end
  end

  describe 'scopes' do
    before(:each) do
      load_user
      @user.join(@building)
    end

    it 'occupied/vacant' do
      expect(@building.units.occupied.count).to eq 0
      expect(@building.units.vacant.count).to eq 1
      @tenancy = Tenancy.create(user: @user, unit: @unit, building: @building)
      expect(@building.units.occupied.count).to eq 1
      expect(@building.units.vacant.count).to eq 0
    end
  end
end
