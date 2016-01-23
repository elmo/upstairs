require 'rails_helper'
RSpec.describe Api::TicketsController, type: :controller do
  before(:each) do
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('bandit', 'smokey')
    load_building_with_one_ticket
    sign_in(@user)
  end

  it 'GET index' do
    get :index, building_id: @building.to_param, format: :json
    expect(response.status).to eq 200
  end

  describe 'GET show' do
    it 'finds' do
      get :show, building_id: @building.to_param, id: @ticket.id, format: :json
      expect(response.status).to eq 200
    end

    it 'rescues not found ' do
      get :show, building_id: @building.to_param, id: -1, format: :json
      expect(response.status).to eq 404
      expect(response.body).to be_json_eql({ error: 'not found' }.to_json)
    end
  end

  describe 'POST create' do
    it 'success' do
      expect { post :create, building_id: @building.slug, ticket: valid_ticket_params, format: :json }.to change(Ticket, :count).by(1)
    end

    it 'response code' do
      post :create, building_id: @building.slug, ticket: valid_ticket_params, format: :json
      expect(response.status).to eq 201
      expect(response.body).to be_json_eql({ ticket: TicketSerializer.new(Ticket.last).serializable_hash }.to_json)
    end

    it 'failure' do
      expect { post :create, building_id: @building.slug, ticket: { title: nil, starts: nil, body: nil }, format: :json }.to change(Ticket, :count).by(0)
    end

    it 'response code' do
      post :create, building_id: @building.slug, ticket: { title: nil }, format: :json
      expect(response.status).to eq 400
    end

    it 'response body renders error messages' do
      post :create, building_id: @building.slug, ticket: { title: nil, body: nil, severity: nil, status: nil }, format: :json
      expect(response.body).to be_json_eql({
        errors: [
          'Title Please enter a title for your maintenance issue.',
          "Severity can't be blank",
          "Status can't be blank",
          'Body Please enter the details of your maintenance issue.']
      }.to_json)
    end
  end

  describe 'PUT update' do
    it 'success' do
      expect(@ticket.title).to eq 'title'
      post :update, building_id: @building.slug, id: @ticket.id,  ticket: valid_ticket_params.merge(title: 'updated title'), format: :json
      @ticket.reload
      expect(@ticket.title).to eq 'updated title'
    end

    it 'response code success' do
      post :update, building_id: @building.slug, id: @ticket.id, ticket: valid_ticket_params.merge(title: 'updated title'), format: :json
      expect(response.status).to eq 200
      @ticket.reload
      expect(response.body).to be_json_eql({ ticket: TicketSerializer.new(@ticket).serializable_hash }.to_json)
    end

    it 'response code failure' do
      post :update, building_id: @building.slug, id: @ticket.id, ticket: { title: nil }, format: :json
      expect(response.status).to eq 400
      @ticket.reload
    end

    it 'response body' do
      post :update, building_id: @building.slug, id: @ticket.id, ticket: { title: nil }, format: :json
      expect(response.body).to be_json_eql({ errors: ['Title Please enter a title for your maintenance issue.'] }.to_json)
    end
  end

  describe 'DELETE destroy' do
    it 'deletes' do
      Ticket.any_instance.stub(:destroy).and_return(true)
      delete :destroy, building_id: @building.slug, id: @ticket.id, format: :json
      expect(response.status).to eq 200
      expect(response.body).to be_json_eql({ ticket: TicketSerializer.new(@ticket).serializable_hash }.to_json)
    end

    it 'fails to delete' do
      Ticket.any_instance.stub(:destroy).and_return(false)
      delete :destroy, building_id: @building.slug, id: @ticket.id, format: :json
      expect(response.status).to eq 400
      expect(response.body).to be_json_eql({ ticket: TicketSerializer.new(@ticket).serializable_hash }.to_json)
    end
  end
end
