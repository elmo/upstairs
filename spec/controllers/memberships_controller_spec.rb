require 'rails_helper'
RSpec.describe MembershipsController, type: :controller do
  before(:each) do
    load_valid_building
    load_user
    load_admin
    @user.make_guest(@building)
    @membership = @user.memberships.first
    load_landlord(@building)
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials("bandit","smokey")
    request.env['HTTP_REFERER'] = 'http://www.upstairs.io'
  end

  describe 'PUT grant' do
    before(:each) do
     sign_in(@admin)
    end
    it "grants landlordship" do
      user = @membership.user
      expect(user.landlord_of?(@building)).to be false
      put :grant, id: @membership.to_param, building_id: @building.to_param, id: @membership.id, membership_type: Membership::MEMBERSHIP_TYPE_LANDLORD
      user.reload
      expect(user.landlord_of?(@building)).to be true
      expect(response).to redirect_to 'http://www.upstairs.io'
    end

   it "grants managership" do
     user = @membership.user
     expect(user.manager_of?(@building)).to be false
     put :grant, id: @membership.to_param, building_id: @building.to_param, id: @membership.id, membership_type: Membership::MEMBERSHIP_TYPE_MANAGER
     user.reload
     expect(user.manager_of?(@building)).to be true
     expect(response).to redirect_to 'http://www.upstairs.io'
   end

   it "grants tenantship" do
     user = @membership.user
     expect(user.tenant_of?(@building)).to be false
     put :grant, id: @membership.to_param, building_id: @building.to_param, id: @membership.id, membership_type: Membership::MEMBERSHIP_TYPE_TENANT
     user.reload
     expect(user.tenant_of?(@building)).to be true
     expect(response).to redirect_to 'http://www.upstairs.io'
   end
 end

  describe 'PUT revoke' do
    before(:each) do
     sign_in(@admin)
    end

    it "revokes landlordship" do
      user = @membership.user
      user.make_landlord(@building)
      @membership = user.memberships.last
      expect(user.landlord_of?(@building)).to be true
      put :revoke, id: @membership.to_param, building_id: @building.to_param, id: @membership.id, membership_type: Membership::MEMBERSHIP_TYPE_LANDLORD
      user.reload
      expect(user.landlord_of?(@building)).to be false
      expect(response).to redirect_to 'http://www.upstairs.io'
    end

   it "grants managership" do
     user = @membership.user
     user.make_manager(@building)
     @membership = user.memberships.last
     expect(user.manager_of?(@building)).to be true
     put :revoke, id: @membership.to_param, building_id: @building.to_param, id: @membership.id, membership_type: Membership::MEMBERSHIP_TYPE_MANAGER
     user.reload
     expect(user.manager_of?(@building)).to be false
     expect(response).to redirect_to 'http://www.upstairs.io'
   end

   it "grants tenantship" do
     user = @membership.user
     user.make_tenant(@building)
     @membership = user.memberships.last
     expect(user.tenant_of?(@building)).to be true
     put :revoke, id: @membership.to_param, building_id: @building.to_param, id: @membership.id, membership_type: Membership::MEMBERSHIP_TYPE_TENANT
     user.reload
     expect(user.tenant_of?(@building)).to be false
     expect(response).to redirect_to 'http://www.upstairs.io'
   end

 end
end
