require 'rails_helper'

RSpec.describe VerificationRequestsController, type: :controller do
  describe "user creating" do

  before(:each) do
    Building.any_instance.stub(:geocode).and_return(true)
    Building.any_instance.stub(:reverse_geocode).and_return(true)
    request.env["HTTP_REFERER"] = "http://www.upstairs.io"
    load_valid_building
    load_user
    sign_in(@user)
  end

  let(:valid_attributes) { {status: 'New'} }
  let(:invalid_attributes) { {status: 'New'} }
  let(:valid_session) { {status: 'New'} }

  describe "GET #new" do
    it "assigns a new verification_request as @verification_request" do
      get :new, { building_id: @building.to_param }, valid_session
      expect(response).to be_success
      expect(assigns(:verification_request)).to be_a_new(VerificationRequest)
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
        expect(response).to redirect_to(building_url(@building))
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved verification_request as @verification_request" do
        post :create, {building_id: @building.to_param , :verification_request => invalid_attributes}, valid_session
        expect(response).to redirect_to(building_url(@building))
      end

      it "re-renders the 'new' template" do
        post :create, {building_id: @building.to_param , :verification_request => invalid_attributes}, valid_session
        expect(response).to redirect_to(building_url(@building))
      end
    end
  end

  end # user creating

  describe "admin approval" do

    before(:each) do
      Building.any_instance.stub(:geocode).and_return(true)
      Building.any_instance.stub(:reverse_geocode).and_return(true)
      request.env["HTTP_REFERER"] = "http://www.upstairs.io"
      load_valid_building
      load_user
      load_verifier
      sign_in(@verifier)
      @valid_attributes = { status: 'New', user_id: @user.id, building_id: @building.id }
      @verification_request = @building.verification_requests.create! @valid_attributes
    end
    let(:invalid_attributes) { {status: 'New'} }
    let(:valid_session) { {status: 'New'} }

  describe "GET #index" do
    it "assigns all verification_requests as @verification_requests" do
      get :index, {}, valid_session
      expect(assigns(:verification_requests)).to eq([@verification_request])
    end
  end

  describe "GET #show" do
    it "assigns the requested verification_request as @verification_request" do
      get :show, {building_id: @building.to_param, :id => @verification_request.to_param}, valid_session
      expect(assigns(:verification_request)).to eq(@verification_request)
    end
  end

  describe "GET #edit" do
    it "assigns the requested verification_request as @verification_request" do
      get :edit, { building_id: @building.to_param, :id => @verification_request.to_param}, valid_session
      expect(response).to be_success
    end
  end

  describe "PUT #update" do
    before(:each) do
      load_valid_verification_request
      @valid_attributes = {user_id: @user.id, building_id: @building.id, status: 'New' }
      @invalid_attributes = {user_id: @user.id, buliding_id: nil, status: nil }
    end

    context "with valid params" do
      let(:new_attributes) { {user_id: @user.id, building_id: @building.id } }

      it "updates the requested verification_request" do
        put :update, { :id => @verification_request.to_param, :verification_request => new_attributes}, valid_session
	expect(response).to redirect_to verification_requests_url
      end

      it "assigns the requested verification_request as @verification_request" do
        put :update, {:id => @verification_request.to_param, :verification_request => @valid_attributes}, valid_session
        expect(assigns(:verification_request)).to eq(@verification_request)
      end

      it "redirects to the verification_request" do
        put :update, {:id => @verification_request.to_param, :verification_request => @valid_attributes}, valid_session
        expect(response).to redirect_to(verification_requests_url)
      end
    end

    context "with invalid params" do
      it "assigns the verification_request as @verification_request" do
        put :update, { :id => @verification_request.to_param, :verification_request => @invalid_attributes }, valid_session
        expect(assigns(:verification_request)).to eq(@verification_request)
      end

      it "re-renders the 'edit' template" do
        put :update, {:id => @verification_request.to_param, :verification_request => @invalid_attributes}, valid_session
        expect(response).to be_success
        expect(response).to render_template(:edit)
        expect(assigns(:verification_request).errors).to be_present
      end
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      load_valid_verification_request
    end
     it "destroys the requested verification_request" do
       expect {
         delete :destroy, {:id => @verification_request.to_param}, valid_session
       }.to change(VerificationRequest, :count).by(-1)
     end

     it "redirects to the verification_requests list" do
       delete :destroy, {:id => @verification_request.to_param}, valid_session
       expect(response).to redirect_to(verification_requests_url)
     end
   end
 end #admin approval
end
