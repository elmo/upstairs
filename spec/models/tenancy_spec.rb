require 'rails_helper'
RSpec.describe Tenancy, type: :model do
  it { should belong_to(:unit) }
  it { should belong_to(:user) }
  it { should belong_to(:building) }

  before(:each) do
    load_valid_building_with_unit
  end

  it "has units" do
    expect(@building.units.count).to eq 1
  end

  describe "tenancy" do
    before(:each) do
      load_user
    end

    it "creates tenancy" do
      expect { Tenancy.create!(user: @user, unit: @unit, building: @building) }.to change(Tenancy, :count).by(1)
    end

    it "does not create tenancy without user" do
      expect { Tenancy.create!(unit: @unit, building: @building) }.to raise_error ActiveRecord::RecordInvalid
    end

    it "does not create tenancy without unit" do
      expect { Tenancy.create!(user: @user, building: @building) }.to raise_error ActiveRecord::RecordInvalid
    end

    it "does not create tenancy without building" do
      expect { Tenancy.create!(user: @user, unit: @unit) }.to raise_error ActiveRecord::RecordInvalid
    end

    before(:each) do
      @tenancy = create(:tenancy, user: @user, unit: @unit, building: @building)
    end

    it "is associated with user" do
      expect(@tenancy.user).to eq(@user)
    end

    it "is associated with unit" do
      expect(@tenancy.unit).to eq(@unit)
    end

    it "is associated with the building" do
      expect(@tenancy.building).to eq(@building)
    end

  end
end
