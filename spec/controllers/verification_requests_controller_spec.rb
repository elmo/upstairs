require 'rails_helper'

RSpec.describe VerificationRequestsController, type: :controller do

  before(:each) do
    Building.any_instance.stub(:geocode).and_return(true)
    Building.any_instance.stub(:reverse_geocode).and_return(true)
    request.env["HTTP_REFERER"] = "http://www.upstairs.io"
    load_valid_building
    load_user
    sign_in(@user)
  end

  let(:valid_attributes) {
    {status: 'New'}
  }

  let(:invalid_attributes) { {status: 'New'} }

  let(:valid_session) { {status: 'New'} }

  describe "GET #index" do
    it "assigns all verification_requests as @verification_requests" do
      verification_request = @building.verification_requests.create! valid_attributes.merge(user_id: @user.id)
      get :index, {building_id: @building.to_param}, valid_session
      expect(assigns(:verification_requests)).to eq([verification_request])
    end
  end

  describe "GET #show" do
    it "assigns the requested verification_request as @verification_request" do
      verification_request = @building.verification_requests.create! valid_attributes.merge(user_id: @user.id)
      get :show, {building_id: @building.to_param, :id => verification_request.to_param}, valid_session
      expect(assigns(:verification_request)).to eq(verification_request)
    end
  end

  describe "GET #new" do
    it "assigns a new verification_request as @verification_request" do
      get :new, { building_id: @building.to_param }, valid_session
      expect(assigns(:verification_request)).to be_a_new(VerificationRequest)
    end
  end

  describe "GET #edit" do
    it "assigns the requested verification_request as @verification_request" do
      verification_request = @building.verification_requests.create! valid_attributes.merge(user_id: @user.id)
      get :edit, { building_id: @building.to_param, :id => verification_request.to_param}, valid_session
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new VerificationRequest" do
        expect {
          post :create, { building_id: @building.to_param , :verification_request => valid_attributes}, valid_session
        }.to change(VerificationRequest, :count).by(1)
      end

      it "assigns a newly created verification_request as @verification_request" do
        post :create, {building_id: @building.to_param, :verification_request => valid_attributes}, valid_session
        expect(assigns(:verification_request)).to be_a(VerificationRequest)
        expect(assigns(:verification_request)).to be_persisted
      end

      it "redirects to the created verification_request" do
        post :create, {building_id: @building.to_param , :verification_request => valid_attributes}, valid_session
        expect(response).to redirect_to(building_verification_request_url(@building, VerificationRequest.last))
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved verification_request as @verification_request" do
        post :create, {building_id: @building.to_param , :verification_request => invalid_attributes}, valid_session
        expect(response).to redirect_to(building_verification_request_url(@building, VerificationRequest.last))
      end

      it "re-renders the 'new' template" do
        post :create, {building_id: @building.to_param , :verification_request => invalid_attributes}, valid_session
        expect(response).to redirect_to(building_verification_request_url(@building, VerificationRequest.last))
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {user_id: @user.id}
      }

      it "updates the requested verification_request" do
        verification_request = @building.verification_requests.create! valid_attributes.merge(user_id: @user.id)
        put :update, { building_id: @building.to_param , :id => verification_request.to_param, :verification_request => new_attributes}, valid_session
        verification_request.reload
	expect(response).to be_redirect
      end

      it "assigns the requested verification_request as @verification_request" do
        verification_request = @building.verification_requests.create! valid_attributes.merge(user_id: @user.id)
        put :update, {building_id: @building.to_param, :id => verification_request.to_param, :verification_request => valid_attributes}, valid_session
        expect(assigns(:verification_request)).to eq(verification_request)
      end

      it "redirects to the verification_request" do
        verification_request = @building.verification_requests.create! valid_attributes.merge(user_id: @user.id)
        put :update, {building_id: @building.to_param , :id => verification_request.to_param, :verification_request => valid_attributes}, valid_session
        expect(response).to redirect_to(building_verification_request_url(@building, verification_request))
      end
    end

    context "with invalid params" do
      it "assigns the verification_request as @verification_request" do
        verification_request = @building.verification_requests.create! valid_attributes.merge(user_id: @user.id)
        put :update, { building_id: @building.to_param, :id => verification_request.to_param, :verification_request => invalid_attributes }, valid_session
        expect(assigns(:verification_request)).to eq(verification_request)
      end

      it "re-renders the 'edit' template" do
        verification_request = @building.verification_requests.create! valid_attributes.merge(user_id: @user.id)
        put :update, { building_id: @building.to_param , :id => verification_request.to_param, :verification_request => invalid_attributes}, valid_session
        expect(response).to redirect_to(building_verification_request_url(@building, VerificationRequest.last))
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested verification_request" do
      verification_request = @building.verification_requests.create! valid_attributes.merge(user_id: @user.id)
      expect {
        delete :destroy, {building_id: @building.to_param, :id => verification_request.to_param}, valid_session
      }.to change(VerificationRequest, :count).by(-1)
    end

    it "redirects to the verification_requests list" do
      verification_request = @building.verification_requests.create! valid_attributes.merge(user_id: @user.id)
      delete :destroy, {building_id: @building.to_param, :id => verification_request.to_param}, valid_session
      expect(response).to redirect_to(building_verification_requests_url(@building))
    end
  end

end
