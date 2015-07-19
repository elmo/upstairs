require 'rails_helper'
RSpec.describe MessagesController, :type => :controller do
  let(:valid_attributes) { {body: "body"} }
  let(:invalid_attributes) { {body: nil} }

  before(:each) do
     load_valid_building
     @sender = create(:user, email: "sender@email.com")
     @recipient = create(:user, email: "recipient@email.com")
     sign_in(@sender)
  end

  describe "GET index" do
    it "assigns all messages as @messages" do
      create_valid_message
      get :index, building_id: @building.to_param
      expect(assigns(:messages)).to eq([@message])
    end
  end

  describe "GET show" do
    it "assigns the requested message as @message" do
      create_valid_message
      get :show, {building_id: @building.to_param, :id => @message.to_param}
      expect(assigns(:message)).to eq(@message)
    end
  end

  describe "GET new" do
    it "assigns a new message as @message" do
      get :new, building_id: @building.to_param
      expect(assigns(:message)).to be_a_new(Message)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Message" do
        expect {
          post :create, {building_id: @building.to_param, user_id: @recipient.slug, :message => valid_attributes}
        }.to change(Message, :count).by(1)
      end

      it "assigns a newly created message as @message" do
        post :create, {building_id: @building.to_param, user_id: @recipient.slug, :message => valid_attributes}
        expect(assigns(:message)).to be_a(Message)
        expect(assigns(:message)).to be_persisted
      end

      it "redirects to the created message" do
        post :create, {building_id: @building.to_param, user_id: @recipient.slug, :message => valid_attributes}
        expect(response).to redirect_to outbox_path(@building, @sender)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved message as @message" do
        post :create, {building_id: @building.to_param, :message => invalid_attributes}
        expect(assigns(:message)).to be_a_new(Message)
      end

      it "re-renders the 'new' template" do
        post :create, {building_id: @building.to_param, :message => invalid_attributes}
        expect(response).to render_template("new")
      end
    end
  end
end
