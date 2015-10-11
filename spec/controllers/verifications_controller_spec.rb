require 'rails_helper'

RSpec.describe VerificationsController, type: :controller do

  before(:each) do
    Building.any_instance.stub(:geocode).and_return(true)
    Building.any_instance.stub(:reverse_geocode).and_return(true)
    request.env["HTTP_REFERER"] = "http://www.upstairs.io"
    load_valid_building
    load_verifier
    load_user
    load_valid_verification_request
    sign_in(@verifier)
    @verifier.add_role(:admin)
  end

  let(:valid_attributes) {
    {
      verification_request_id: @verification_request.id,
      verifier_id: @verifier.id,
      building_id: @verification_request.building.id,
      user_id: @verification_request.user.id
    }
  }

  let(:invalid_attributes) {
    {
      verification_request_id: nil,
      verifier_id: @verifier.id,
    }
  }

  let(:valid_session) { {user_id: @verifier.id} }

  describe "GET #index" do
    it "assigns all verifications as @verifications" do
      verification = Verification.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:verifications)).to eq([verification])
    end
  end

  describe "GET #new" do
    it "assigns a new verification as @verification" do
      get :new, {verification_request_id: @verification_request.id}, valid_session
      expect(assigns(:verification)).to be_a_new(Verification)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Verification" do
        expect {
          post :create, {verification_request_id: @verification_request.id}, valid_session
        }.to change(Verification, :count).by(1)
      end

      it "assigns a newly created verification as @verification" do
        post :create, {verification_request_id: @verification_request.id, :verification => valid_attributes}, valid_session
        expect(assigns(:verification)).to be_a(Verification)
        expect(assigns(:verification)).to be_persisted
      end

      it "redirects to the created verification" do
        post :create, {verification_request_id: @verification_request.id, :verification => valid_attributes}, valid_session
        expect(response).to redirect_to verification_requests_url
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested verification" do
      verification = Verification.create! valid_attributes
      expect {
        delete :destroy, {:id => verification.to_param}, valid_session
      }.to change(Verification, :count).by(-1)
    end

    it "redirects to the verifications list" do
      verification = Verification.create! valid_attributes
      delete :destroy, {:id => verification.to_param}, valid_session
      expect(response).to redirect_to(verifications_url)
    end
  end

end
