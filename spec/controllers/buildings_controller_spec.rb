require 'rails_helper'
RSpec.describe BuildingsController, type: :controller do
  let(:valid_attributes) do
    {
      address:  '123 Main Street, San Francisco, CA 94121'
    }
  end
  let(:invalid_attributes) {}

  before(:each) do
    Building.any_instance.stub(:geocode).and_return(true)
    Building.any_instance.stub(:reverse_geocode).and_return(true)
    request.env['HTTP_REFERER'] = 'http://www.upstairs.io'
    load_user
    sign_in(@user)
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials("bandit","smokey")
  end

  describe 'GET show' do
    describe  'renders template based on membership type:' do
      before(:each) do
        load_valid_building
      end

      it 'guest' do
         @building.grant_guestship(@user)
         @building.reload
	 @user.reload
         get :show, id: @building.slug
         expect(assigns(:building)).to eq(@building)
         expect(assigns(:subdirectory)).to eq('guests')
      end

      it 'tenant' do
         @building.grant_tenantship(@user)
         @building.reload
	 @user.reload
         get :show, id: @building.slug
         expect(assigns(:building)).to eq(@building)
         expect(assigns(:subdirectory)).to eq('tenants')
      end

      it 'manager' do
         @building.grant_managership(@user)
         @building.reload
	 @user.reload
         get :show, id: @building.slug
         expect(assigns(:building)).to eq(@building)
         expect(assigns(:subdirectory)).to eq('managers')
      end

      it 'landlord' do
         @building.grant_landlordship(@user)
         @building.reload
	 @user.reload
         get :show, id: @building.slug
         expect(assigns(:building)).to eq(@building)
         expect(assigns(:subdirectory)).to eq('landlords')
      end

    end
  end
end
