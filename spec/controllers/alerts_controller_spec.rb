require 'rails_helper'
RSpec.describe AlertsController, type: :controller do
  let(:valid_attributes) { { message: 'message' } }
  let(:invalid_attributes) { { message: nil } }

  before(:each) do
    load_valid_building
    load_user
    sign_in(@user)
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('bandit', 'smokey')
  end

  describe 'GET index' do
    it 'assigns all alerts as @alerts' do
      create_valid_alert
      get :index, building_id: @building.to_param
      expect(assigns(:alerts)).to eq([@alert])
    end
  end

  describe 'GET show' do
    it 'assigns the requested alert as @alert' do
      create_valid_alert
      get :show, building_id: @building.to_param, id: @alert.to_param
      expect(assigns(:alert)).to eq(@alert)
    end
  end

  describe 'GET new' do
    it 'assigns a new alert as @alert' do
      get :new,  building_id: @building.to_param
      expect(assigns(:alert)).to be_a_new(Alert)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested alert as @alert' do
      create_valid_alert
      get :edit, building_id: @building.to_param, id: @alert.to_param
      expect(assigns(:alert)).to eq(@alert)
    end
  end

  describe 'ALERT create' do
    describe 'with valid params' do
      it 'creates a new Alert' do
        expect do
          post :create,  building_id: @building.to_param, alert: valid_attributes
        end.to change(Alert, :count).by(1)
      end

      it 'assigns a newly created alert as @alert' do
        post :create,  building_id: @building.to_param, alert: valid_attributes
        expect(assigns(:alert)).to be_a(Alert)
        expect(assigns(:alert)).to be_persisted
      end

      it 'redirects to the created alert' do
        post :create,  building_id: @building.to_param, alert: valid_attributes
        expect(response).to redirect_to building_alerts_path(@building)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved alert as @alert' do
        post :create,  building_id: @building.to_param, alert:  invalid_attributes
        expect(assigns(:alert)).to be_a_new(Alert)
      end

      it "re-renders the 'new' template" do
        post :create,  building_id: @building.to_param, alert: invalid_attributes
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      let(:new_attributes) { { title: 'new title',  body: 'new body' } }

      it 'updates the requested alert' do
        create_valid_alert
        put :update, building_id: @building.slug, id:  @alert.to_param, alert: new_attributes
        @alert.reload
        expect(response).to redirect_to(building_alerts_path(@building))
      end

      it 'assigns the requested alert as @alert' do
        create_valid_alert
        put :update, id: @alert.to_param,  building_id: @building.slug, alert: valid_attributes
        expect(assigns(:alert)).to eq(@alert)
      end

      it 'redirects to the alert' do
        create_valid_alert
        put :update, id: @alert.to_param,  building_id: @building.slug, alert: valid_attributes
        expect(response).to redirect_to(building_alerts_path(@building))
      end
    end

    describe 'with invalid params' do
      it 'assigns the alert as @alert' do
        create_valid_alert
        put :update, building_id: @building.slug, id: @alert.to_param, alert: invalid_attributes
        expect(assigns(:alert)).to eq(@alert)
      end

      it "re-renders the 'edit' template" do
        create_valid_alert
        put :update, building_id: @building.slug, id: @alert.to_param, alert: invalid_attributes
        expect(response).to render_template('edit')
      end
    end
  end
end
