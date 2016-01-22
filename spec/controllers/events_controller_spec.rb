require 'rails_helper'
RSpec.describe EventsController, type: :controller do
  let(:valid_attributes) { { title: 'title', body: 'body', starts: (Date.today + 2.days).strftime('%Y-%m-%d') } }
  let(:invalid_attributes) { { body: nil, title: nil } }

  before(:each) do
    Event.any_instance.stub(:create_notifications).and_return(true)
    Event.any_instance.stub(:photos).and_return([])
    request.env['HTTP_REFERER'] = 'http://www.upstairs.io'
    load_valid_building
    load_user
    sign_in(@user)
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('bandit', 'smokey')
  end

  describe 'GET index' do
    it 'assigns all events as @events' do
      create_valid_event
      get :index, building_id: @building.slug
      expect(assigns(:events)).to eq([@event])
    end
  end

  describe 'GET show' do
    it 'assigns the requested event as @event' do
      create_valid_event
      get :show, id: @event.to_param, building_id: @building.slug
      expect(assigns(:event)).to eq(@event)
    end
  end

  describe 'GET new' do
    it 'assigns a new event as @event' do
      get :new, building_id: @building.slug
      expect(assigns(:event)).to be_a_new(Event)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested event as @event' do
      create_valid_event
      get :edit, id: @event.to_param, building_id: @building.slug
      expect(assigns(:event)).to eq(@event)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Event' do
        expect do
          post :create, event: valid_attributes, building_id: @building.slug
        end.to change(Event, :count).by(1)
      end

      it 'assigns a newly created event as @event' do
        post :create, event: valid_attributes, building_id: @building.slug
        expect(assigns(:event)).to be_a(Event)
        expect(assigns(:event)).to be_persisted
      end

      it 'redirects to the created event' do
        post :create, building_id: @building.slug, event: valid_attributes
        expect(response).to redirect_to building_events_path(@building)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved event as @event' do
        post :create, event: invalid_attributes, building_id: @building.slug
        expect(assigns(:event)).to be_a_new(Event)
      end

      it "re-renders the 'new' template" do
        post :create, event: invalid_attributes, building_id: @building.slug
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      let(:new_attributes) do
        {
          body: 'new body'
        }
      end

      it 'updates the requested event' do
        create_valid_event
        put :update, id: @event.to_param, event: new_attributes, building_id: @building.slug
        @event.reload
        expect(response).to redirect_to building_events_path(@building)
      end

      it 'assigns the requested event as @event' do
        create_valid_event
        put :update, id: @event.to_param, event: valid_attributes, building_id: @building.slug
        expect(assigns(:event)).to eq(@event)
      end

      it 'redirects to the event' do
        create_valid_event
        put :update, id: @event.to_param, event: valid_attributes, building_id: @building.slug
        expect(response).to redirect_to building_events_path(@building)
      end
    end

    describe 'with invalid params' do
      it 'assigns the event as @event' do
        create_valid_event
        put :update, id: @event.to_param, event: invalid_attributes, building_id: @building.slug
        expect(assigns(:event)).to eq(@event)
      end

      it "re-renders the 'edit' template" do
        create_valid_event
        put :update, id: @event.to_param, event: invalid_attributes, building_id: @building.slug
        expect(response).to render_template('edit')
      end
    end
  end
end
