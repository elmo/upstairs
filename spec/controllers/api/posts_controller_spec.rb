require 'rails_helper'
RSpec.describe Api::BuildingsController, type: :controller do

  before(:each) do
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials("bandit","smokey")
    load_valid_building
  end

  it 'GET show' do
    get :index, building_id: @building.to_param, format: :json
    expect(response.status).to eq 200
    expect(response.body).to be_json_eql({building: @building}.to_json )
    expect(assigns(:building)).to eq @building
  end

end
