require 'rails_helper'
RSpec.describe Api::AlertsController, type: :controller do

  before(:each) do
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials("bandit","smokey")
    load_valid_building
    load_user
    create_valid_alert
  end

  it 'GET index' do
    get :index, building_id: @building.to_param, format: :json
    expect(response.status).to eq 200
  end

  it 'GET show' do
    get :show, building_id: @building.to_param, id: @alert.id, format: :json
    expect(response.status).to eq 200
  end

end
