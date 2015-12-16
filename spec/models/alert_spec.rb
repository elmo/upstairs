require 'rails_helper'

RSpec.describe Alert, type: :model do
  it  { should belong_to(:user) }
  it  { should belong_to(:building) }
  it  { should have_many(:notifications) }
  it  { should validate_presence_of(:user) }
  it  { should validate_presence_of(:building) }

  describe 'alert' do
    before(:each) do
      load_valid_building
      load_user
      @user.join(@building)
      Notification.any_instance.stub(:deliver_later).and_return(true)
    end

    it 'creates' do
      expect { Alert.create(user: @user, building: @building, message: 'message') }.to change(Alert, :count).by(1)
    end

    it 'creates an activity' do
      expect { Alert.create(user: @user, building: @building, message: 'message') }.to change(Activity, :count).by(1)
    end

    it 'creates a notification' do
      expect { Alert.create(user: @user, building: @building, message: 'message') }.to change(Notification, :count).by(1)
    end

    describe "owned_by?" do
      it "true when creator matches passed in user" do
        @alert = Alert.create(user: @user, building: @building, message: 'message')
        expect(@alert.owned_by?(@user)).to be true
      end

      it "false when creator does not matche passed in user" do
        @alert = Alert.create(user: @user, building: @building, message: 'message')
	@other_user = create(:user, email: "#{SecureRandom.hex(5)}-@email.com")
        expect(@alert.owned_by?(@other_user)).to be false
      end
    end

    describe "recent" do
      before(:each) do
        Timecop.freeze(2015,1,1)
      end
      it 'older than 12 hours are not recent ' do
        Alert.create(user: @user, building: @building, message: 'message', created_at: Time.zone.now - 13.hours)
        expect(Alert.recent.count).to eq 0
      end

      it 'more recent than 12 hours are recent ' do
        @alert = Alert.create(user: @user, building: @building, message: 'message', created_at: Time.zone.now - 11.hours)
        expect(Alert.recent.count).to eq 1
      end
    end

    it 'for_user' do
      expect(Alert.for_user(@user).count).to eq 0
      Alert.create(user: @user, building: @building, message: 'message')
      expect(Alert.for_user(@user).count).to eq 1
    end
  end

end
