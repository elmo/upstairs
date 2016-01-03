require 'rails_helper'
RSpec.describe Api::TicketsController, type: :controller do

  before(:each) do
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials("bandit","smokey")
    Ticket.any_instance.stub(:create_notifications).and_return(true)
    load_building_with_one_ticket
  end

  it 'GET show' do
    get :show, building_id: @building.to_param, id: @ticket.id, format: :json
    expect(response.status).to eq 200
    expect(response.body).to be_json_eql({ticket: @ticket}.to_json )
    expect(assigns(:ticket)).to eq @ticket
  end

  it 'GET index' do
    get :index, building_id: @building.to_param, format: :json
    expect(response.status).to eq 200
  end

end
