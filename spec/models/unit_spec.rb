require 'rails_helper'
RSpec.describe Unit, type: :model do
  it { should belong_to(:building) }
  it { should have_one(:tenancy) }
  it { should validate_presence_of(:building_id) }
  it { should validate_presence_of(:name) }

  before(:each) do
    load_valid_building
  end

  it 'creates with bulding and name' do
    expect { Unit.create!(building: @building, name: 'one') }.to change(Unit, :count).by(1)
  end

  it 'does not create without bulding' do
    expect { Unit.create!(name: 'one') }.to raise_error ActiveRecord::RecordInvalid
  end

  it 'does not create without name' do
    expect { Unit.create!(building: @building) }.to raise_error ActiveRecord::RecordInvalid
  end

  describe 'create tenancy' do
    before(:each) do
      load_user
      load_another_user
      @unit = Unit.create(building: @building, name: 'one')
    end

    it 'creates tenancy when none exists' do
      expect { @unit.create_tenancy_for(user: @user) }.to change(Tenancy, :count).by(1)
    end

    it 'creates tenancy when none exists' do
      expect(@unit.create_tenancy_for(user: @user)).to be_truthy
    end

    it "doesn't created another tenancy when one exists" do
      @unit.create_tenancy_for(user: @user)
      @unit.reload
      expect { @unit.create_tenancy_for(user: @user) }.to change(Tenancy, :count).by(0)
    end

    it 'destroys existing, creates a new tenancy if the users are different' do
      @unit.create_tenancy_for(user: @user)
      @unit.reload
      first_tenancy = Tenancy.last
      expect { @unit.create_tenancy_for(user: @user2) }.to change(Tenancy, :count).by(0)
      last_tenancy = Tenancy.last
      expect(first_tenancy.id).not_to eq last_tenancy.id
    end
  end
end
