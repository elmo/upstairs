require 'rails_helper'
RSpec.describe Api::UserController, type: :controller do
  before(:each) do
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('bandit', 'smokey')
    load_user
  end

  it 'GET show' do
    get :show, id: @user.id, format: :json
    expect(response.status).to eq 200
    expect(response.body).to be_json_eql({ user: @user }.to_json)
    expect(assigns(:user)).to eq @user
  end
end
