require 'rails_helper'
RSpec.describe Api::PostsController, type: :controller do

  before(:each) do
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials("bandit","smokey")
    load_building_with_one_post
  end

  it 'GET show' do
    get :show, building_id: @building.to_param, id: @post.slug,  format: :json
    expect(response.status).to eq 200
  end

  it 'GET index' do
    get :index, building_id: @building.to_param, format: :json
    expect(response.status).to eq 200
  end


end
