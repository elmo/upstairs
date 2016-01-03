require 'rails_helper'
RSpec.describe Api::UserController, type: :controller do

  before(:each) do
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials("bandit","smokey")
    load_user
    load_ticket
  end

  it 'GET show' do
    get :show, id: @ticket.id, format: :json
    expect(response.status).to eq 200
    expect(response.body).to be_json_eql({ticket: @ticket}.to_json )
    expect(assigns(:ticket)).to eq @ticket
  end

  it 'GET index' do
    get :index, building_id: @building.to_param, format: :json
    expect(response.status).to eq 200
  end

end
