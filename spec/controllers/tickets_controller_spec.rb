require 'rails_helper'
RSpec.describe TicketsController, type: :controller do
  let(:valid_attributes) { { title: 'title', body: 'body', severity: 'low', status: 'new' } }
  let(:invalid_attributes) { { title: nil, body: nil } }

  before(:each) do
    load_valid_building
    load_user
    sign_in(@user)
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('bandit', 'smokey')
  end

  describe 'GET index' do
    it 'assigns all tickets as @tickets' do
      create_valid_ticket
      get :index, building_id: @building.to_param
      expect(assigns(:tickets)).to eq([@ticket])
    end
  end

  describe 'GET show' do
    it 'assigns the requested ticket as @ticket' do
      create_valid_ticket
      get :show, id: @ticket.to_param, building_id: @building.to_param
      expect(assigns(:ticket)).to eq(@ticket)
    end
  end

  describe 'GET new' do
    it 'assigns a new ticket as @ticket' do
      get :new, building_id: @building.to_param
      expect(assigns(:ticket)).to be_a_new(Ticket)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested ticket as @ticket' do
      create_valid_ticket
      get :edit, id: @ticket.to_param, building_id: @building.to_param
      expect(assigns(:ticket)).to eq(@ticket)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Ticket' do
        expect do
          post :create, building_id: @building.to_param, ticket: valid_attributes
        end.to change(Ticket, :count).by(1)
      end

      it 'assigns a newly created ticket as @ticket' do
        post :create, building_id: @building.to_param, ticket: valid_attributes
        expect(assigns(:ticket)).to be_a(Ticket)
        expect(assigns(:ticket)).to be_persisted
      end

      it 'redirects to the created ticket' do
        post :create, building_id: @building.to_param, ticket: valid_attributes
        expect(response).to redirect_to building_ticket_path(@building, Ticket.last)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved ticket as @ticket' do
        post :create, building_id: @building.to_param, ticket: invalid_attributes
        expect(assigns(:ticket)).to be_a_new(Ticket)
      end

      it "re-renders the 'new' template" do
        post :create, building_id: @building.to_param, ticket: invalid_attributes
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT attribute methods' do
    before(:each) do
      request.env['HTTP_REFERER'] = 'http://www.upstairs.io'
      create_valid_ticket
      @ticket.update_attributes(severity: Ticket::SEVERITY_SERIOUS)
    end

    it 'open' do
      put :open, id: @ticket.to_param, building_id: @building.to_param
      expect(response).to redirect_to 'http://www.upstairs.io'
      expect(Ticket.last.status).to eq Ticket::STATUS_OPEN
    end

    it 'close' do
      put :close, id: @ticket.to_param, building_id: @building.to_param
      expect(response).to redirect_to 'http://www.upstairs.io'
      expect(Ticket.last.status).to eq Ticket::STATUS_CLOSED
    end

    it 'escalate' do
      put :escalate, id: @ticket.to_param, building_id: @building.to_param
      expect(response).to redirect_to 'http://www.upstairs.io'
      expect(Ticket.last.severity).to eq Ticket::SEVERITY_SEVERE
    end

    it 'deescalate' do
      put :deescalate, id: @ticket.to_param, building_id: @building.to_param
      expect(response).to redirect_to 'http://www.upstairs.io'
      expect(Ticket.last.severity).to eq Ticket::SEVERITY_MINOR
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      let(:new_attributes) { { title: 'new title', body: 'new body', severity: 'medium', status: 'closed' } }

      it 'updates the requested ticket' do
        create_valid_ticket
        put :update, id: @ticket.to_param, building_id: @building.to_param, ticket: new_attributes
        @ticket.reload
      end

      it 'assigns the requested ticket as @ticket' do
        create_valid_ticket
        put :update, id: @ticket.to_param, building_id: @building.to_param, ticket: valid_attributes
        expect(assigns(:ticket)).to eq(@ticket)
      end

      it 'redirects to the ticket' do
        create_valid_ticket
        put :update, id: @ticket.to_param, building_id: @building.to_param, ticket: valid_attributes
        expect(response).to redirect_to building_ticket_path(@building, @ticket)
      end
    end

    describe 'with invalid params' do
      it 'assigns the ticket as @ticket' do
        create_valid_ticket
        put :update, id: @ticket.to_param, building_id: @building.to_param, ticket: invalid_attributes
        expect(assigns(:ticket)).to eq(@ticket)
      end

      it "re-renders the 'edit' template" do
        create_valid_ticket
        put :update, id: @ticket.to_param, building_id: @building.to_param, ticket: invalid_attributes
        expect(response).to render_template('edit')
      end
    end
  end
end
