require 'rails_helper'

RSpec.describe Alert, :type => :model do
  it  {should belong_to(:user) }
  it  {should belong_to(:building) }
  it  {should have_many(:notifications) }
  it  {should validate_presence_of(:user) }
  it  {should validate_presence_of(:building) }

  describe "alert" do
    before(:each) do
      load_valid_building
      load_user
      @user.join(@building)
      Notification.any_instance.stub(:deliver_later).and_return(true)
    end

    it "creates" do
     expect{Alert.create(user: @user, building: @building, message: "message") }.to change(Alert, :count).by(1)
    end

    it "creates an activity" do
     expect{Alert.create(user: @user, building: @building, message: "message") }.to change(Activity, :count).by(1)
    end

    it "creates a notification" do
     expect{Alert.create(user: @user, building: @building, message: "message") }.to change(Notification, :count).by(1)
    end

    it "recent" do
     expect(Alert.recent.count).to eq 0
     Alert.create(user: @user, building: @building, message: "message")
     expect(Alert.recent.count).to eq 1
    end

    it "for_user" do
     expect(Alert.for_user(@user).count).to eq 0
     Alert.create(user: @user, building: @building, message: "message")
     expect(Alert.for_user(@user).count).to eq 1
    end

  end

end
