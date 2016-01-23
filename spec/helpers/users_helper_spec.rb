require 'rails_helper'
RSpec.describe UsersHelper, type: :helper do
  before(:each) do
    load_user
    load_valid_building
  end
  describe 'landlord_link' do
    it 'landlord' do
      @user.make_landlord(@building)
      expect(helper.landlord_link(user: @user, building: @building)).to eq 'landlord'
    end
    it 'not landlord' do
      expect(helper.landlord_link(user: @user, building: @building)).to eq ''
    end
  end
end
