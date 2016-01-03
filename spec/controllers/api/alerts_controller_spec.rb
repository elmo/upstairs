require 'rails_helper'
RSpec.describe Api::AlertsController, type: :controller do

  before(:each) do
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials("bandit","smokey")
    load_valid_building
    load_user
    create_valid_alert
    sign_in(@user)
  end

  it 'GET index' do
    get :index, building_id: @building.to_param, format: :json
    expect(response.status).to eq 200
  end

  describe 'GET show' do
    it 'finds' do
      get :show, building_id: @building.to_param, id: @alert.id, format: :json
      expect(response.status).to eq 200
    end

    it 'rescues not found ' do
      get :show, building_id: @building.to_param, id: -1, format: :json
      expect(response.status).to eq 404
      expect(response.body).to be_json_eql({ error: "not found" }.to_json)
    end

  end

  describe 'POST create' do
    it 'success' do
      expect{ post :create, building_id: @building.slug, alert: valid_alert_params, format: :json }.to change(Alert, :count).by(1)
    end

    it 'response code' do
      post :create, building_id: @building.slug, alert: valid_alert_params, format: :json
      expect(response.status).to eq 201
      expect(response.body).to be_json_eql({alert: AlertSerializer.new(Alert.last).attributes}.to_json)
    end


    it 'failure' do
      expect{ post :create, building_id: @building.slug, alert: {message: nil}, format: :json }.to change(Alert, :count).by(0)
    end

    it 'response code' do
      post :create, building_id: @building.slug, alert: {message: nil}, format: :json
      expect(response.status).to eq 400
    end

    it 'response body' do
      post :create, building_id: @building.slug, alert: {message: nil}, format: :json
      expect(response.body).to be_json_eql({errors:["Message can't be blank"]}.to_json)
    end

  end

  describe 'PUT update' do
    it 'success' do
      expect(@alert.message).to eq 'message'
      post :update, building_id: @building.slug, id: @alert.id,  alert: valid_alert_params.merge(message: 'updated message'), format: :json
      @alert.reload
      expect(@alert.message).to eq 'updated message'
    end

    it 'response code success' do
      post :update, building_id: @building.slug, id: @alert.id, alert: valid_alert_params.merge(message: 'updated message'), format: :json
      expect(response.status).to eq 200
      @alert.reload
      expect(response.body).to be_json_eql({alert: AlertSerializer.new(@alert).attributes}.to_json)
    end

    it 'response code failure' do
      post :update, building_id: @building.slug, id: @alert.id, alert: {message: nil}, format: :json
      expect(response.status).to eq 400
      @alert.reload
    end

    it 'response body' do
      post :update, building_id: @building.slug, id: @alert.id, alert: {message: nil}, format: :json
      expect(response.body).to be_json_eql({errors:["Message can't be blank"]}.to_json)
    end
  end

  describe 'DELETE destroy' do

    it 'deletes' do
      delete :destroy, building_id: @building.slug, id: @alert.id, format: :json
      expect(response.status).to eq 200
      expect(response.body).to be_json_eql({alert: AlertSerializer.new(@alert).attributes}.to_json)
    end

    it 'fails to delete' do
      Alert.any_instance.stub(:destroy).and_return(false)
      delete :destroy, building_id: @building.slug, id: @alert.id, format: :json
      expect(response.status).to eq 400
      expect(response.body).to be_json_eql({alert: AlertSerializer.new(@alert).attributes}.to_json)
    end

  end

end
