require 'rails_helper'

RSpec.describe VerificationsController, type: :controller do

  before(:each) do
    Building.any_instance.stub(:geocode).and_return(true)
    Building.any_instance.stub(:reverse_geocode).and_return(true)
    request.env["HTTP_REFERER"] = "http://www.upstairs.io"
    load_valid_building
    load_verifier
    load_user
    sign_in(@verifier)
    @verifier.add_role(:admin)
  end

  let(:valid_attributes) {
    {building_id: @building.id, user_id: @user.id, verifier_id: @verifier.id}
  }

  let(:invalid_attributes) {
    {building_id: -1}
  }

  let(:valid_session) { {user_id: @verifier.id} }

  describe "GET #index" do
    it "assigns all verifications as @verifications" do
      verification = Verification.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:verifications)).to eq([verification])
    end
  end

  describe "GET #show" do
    it "assigns the requested verification as @verification" do
      verification = Verification.create! valid_attributes
      get :show, {:id => verification.to_param}, valid_session
      expect(assigns(:verification)).to eq(verification)
    end
  end

  describe "GET #new" do
    it "assigns a new verification as @verification" do
      get :new, {}, valid_session
      expect(assigns(:verification)).to be_a_new(Verification)
    end
  end

  describe "GET #edit" do
    it "assigns the requested verification as @verification" do
      verification = Verification.create! valid_attributes
      get :edit, {:id => verification.to_param}, valid_session
      expect(assigns(:verification)).to eq(verification)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Verification" do
        expect {
          post :create, {:verification => valid_attributes}, valid_session
        }.to change(Verification, :count).by(1)
      end

      it "assigns a newly created verification as @verification" do
        post :create, {:verification => valid_attributes}, valid_session
        expect(assigns(:verification)).to be_a(Verification)
        expect(assigns(:verification)).to be_persisted
      end

      it "redirects to the created verification" do
        post :create, {:verification => valid_attributes}, valid_session
        expect(response).to redirect_to(Verification.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved verification as @verification" do
        post :create, {:verification => invalid_attributes}, valid_session
        expect(assigns(:verification)).to be_a_new(Verification)
      end

      it "re-renders the 'new' template" do
        post :create, {:verification => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {building_id: @building.id, user_id: @user.id, verifier_id: @verifier.id }
      }

      it "updates the requested verification" do
        verification = Verification.create! valid_attributes
        put :update, {:id => verification.to_param, :verification => new_attributes}, valid_session
        verification.reload
	expect(assigns(:verification).verifier_id).to eq @verifier.id
      end

      it "assigns the requested verification as @verification" do
        verification = Verification.create! valid_attributes
        put :update, {:id => verification.to_param, :verification => valid_attributes}, valid_session
        expect(assigns(:verification)).to eq(verification)
      end

      it "redirects to the verification" do
        verification = Verification.create! valid_attributes
        put :update, {:id => verification.to_param, :verification => valid_attributes}, valid_session
        expect(response).to redirect_to(verification)
      end
    end

    context "with invalid params" do
      it "assigns the verification as @verification" do
        verification = Verification.create! valid_attributes.merge(verifier_id: @verifier.id)
        put :update, {:id => verification.to_param, :verification => invalid_attributes.merge(building_id: -1)}, valid_session
        expect(assigns(:verification)).to eq(verification)
      end

      it "re-renders the 'edit' template" do
        verification = Verification.create! valid_attributes.merge(verifier_id: @verifier.id)
        put :update, {:id => verification.to_param, :verification => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
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
