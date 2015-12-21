require 'rails_helper'
RSpec.describe InvitationsController, type: :controller do
  let(:valid_attributes) { { email: 'recipient@email.com' } }
  let(:invalid_attributes) { { email: nil } }

  before(:each) do
    load_valid_building
    load_user
    sign_in(@user)
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials("bandit","smokey")
  end

  describe 'GET show' do
    it 'assigns the requested invitation as @invitation' do
      create_valid_invitation
      get :show, building_id: @building.id, id: @invitation.to_param
      expect(assigns(:invitation)).to eq(@invitation)
    end
  end

  describe 'GET new' do
    it 'assigns a new invitation as @invitation' do
      get :new, building_id: @building.id
      expect(assigns(:invitation)).to be_a_new(Invitation)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Invitation' do
        expect do
          post :create, building_id: @building.id, invitation: valid_attributes
        end.to change(Invitation, :count).by(1)
      end

      it 'assigns a newly created invitation as @invitation' do
        post :create, building_id: @building.id, invitation: valid_attributes
        expect(assigns(:invitation)).to be_a(Invitation)
        expect(assigns(:invitation)).to be_persisted
      end

      it 'redirects to the created invitation' do
        post :create, building_id: @building.id, invitation: valid_attributes
        expect(response).to redirect_to building_path(@building)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved invitation as @invitation' do
        post :create, building_id: @building.id, invitation: invalid_attributes
        expect(assigns(:invitation)).to be_a_new(Invitation)
      end

      it "re-renders the 'new' template" do
        post :create, building_id: @building.id, invitation: invalid_attributes
        expect(response).to render_template('new')
      end
    end
  end
end
