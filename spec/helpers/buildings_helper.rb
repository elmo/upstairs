require 'rails_helper'
RSpec.describe BuildingsHelper, :type => :helper do

  describe "current_user_view" do
    before(:each) do
      load_user
      load_unverified_builiding
    end

    describe "unverified building" do
      it "a regular non-owner user in an unverfied building" do
        expect(helper).to receive(:render).with({:partial=>"/buildings/member_of_unverified_building_view"}).exactly(1).times
        helper.current_user_view(building: @building, user: @user)
      end
    end

    describe "verified building" do
      before(:each) do
	load_verified_building
      end

      it "a regular non-owner user in an verfied building" do
        expect(helper).to receive(:render).with({:partial=>"/buildings/member_of_verified_building_view"}).exactly(1).times
        helper.current_user_view(building: @building, user: @user)
      end

      it "a building owner user in an verfied building" do
        expect(helper).to receive(:render).with({:partial=>"/buildings/verified_owner_view"}).exactly(1).times
        helper.current_user_view(building: @building, user: @landlord)
      end
    end
  end

  describe "current_user_left_nav" do
    before(:each) do
      load_user
      load_unverified_builiding
    end

    describe "unverified building" do
      it "a regular non-owner user in an unverfied building" do
        expect(helper).to receive(:render).with({:partial=>"/buildings/owner_not_verified_left_nav"}).exactly(1).times
        helper.current_user_left_nav(building: @building, user: @user)
      end
    end

    describe "verified building" do
      before(:each) do
	load_verified_building
      end

      it "a regular non-owner user in an verfied building" do
        expect(helper).to receive(:render).with({:partial=>"/buildings/owner_verified_left_nav"}).exactly(1).times
        helper.current_user_left_nav(building: @building, user: @user)
      end
    end
  end

  describe "alert_bar" do
    before(:each) do
      load_user
      load_unverified_builiding
    end

    it "renders alerts template" do
      expect(helper).to receive(:render).with({:partial=>"/buildings/alerts"}).exactly(1).times
      helper.alert_bar(building: @building, user: @user)
    end
  end

  describe "upstairs_home_page_icon" do
    it "returns link" do
      expect(helper.upstairs_home_page_icon).to eq "<div><a href=\"http://test.host/\">upstairs</a></div>"
    end
  end

  describe "building specific links" do

    before(:each) do
      load_unverified_builiding
    end

    it "building_home_icon" do
      expect(helper.building_home_icon(building: @building)).to eq "<div><a href=\"/buildings/123-main-street-san-francisco-ca-94121\">home</a></div>"
    end

    it "building_bulletin_board_icon" do
      expect(helper.building_bulletin_board_icon(building: @building)).to eq "<div><a href=\"/buildings/123-main-street-san-francisco-ca-94121/posts\">bulletin</a></div>"
    end

    it "building_alerts_icon" do
      expect(helper.building_alerts_icon(building: @building)).to eq "<div><a href=\"/buildings/123-main-street-san-francisco-ca-94121/posts\">alerts</a></div>"
    end

    it "building_calendar_icon" do
      expect(helper.building_calendar_icon(building: @building)).to eq "<div><a href=\"/buildings/123-main-street-san-francisco-ca-94121/events\">calendar</a></div>"
    end

    it "building_messages_icon" do
      expect(helper.building_messages_icon(building: @building)).to eq "<div><a href=\"/buildings/123-main-street-san-francisco-ca-94121/inbox\">messages</a></div>"
    end

    it "building_members_icon" do
      expect(helper.building_members_icon(building: @building)).to eq "<div><a href=\"/buildings/123-main-street-san-francisco-ca-94121/memberships\">members</a></div>"
    end

    it "building_repairs_icon" do
      expect(helper.building_repairs_icon(building: @building)).to eq "<div><a href=\"/buildings/123-main-street-san-francisco-ca-94121/tickets\">repairs</a></div>"
    end

    it "building_invite_icon" do
      expect(helper.building_invite_icon(building: @building)).to eq "<div><a href=\"/buildings/123-main-street-san-francisco-ca-94121/invitations/new\">invite</a></div>"
    end

    it "building_public_profile_icon" do
      load_user
      @user.stub(:slug).and_return('static-slug')
      expect(helper.building_public_profile_icon(building: @building, user: @user)).to eq "<div><a href=\"/buildings/123-main-street-san-francisco-ca-94121/users/static-slug\">public profile</a></div>"
    end
  end
end
