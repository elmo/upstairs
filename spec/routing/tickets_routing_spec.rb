require 'rails_helper'

RSpec.describe TicketsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/buildings/1/tickets').to route_to('tickets#index', building_id: "1" )
    end

    it 'routes to #show' do
      expect(get: '/buildings/1/tickets/1').to route_to('tickets#show', building_id: "1", id: "1" )
    end

    it 'routes to #edit' do
      expect(get: '/buildings/1/tickets/1/edit').to route_to('tickets#edit', building_id: "1", id: "1" )
    end

    it 'routes to #create' do
      expect(post: '/buildings/1/tickets').to route_to('tickets#create', building_id: "1" )
    end

    it 'routes to #update' do
      expect(put: '/buildings/1/tickets/1').to route_to('tickets#update', building_id: "1", id: "1" )
    end

    it 'routes to #destroy' do
      expect(delete: '/buildings/1/tickets/1').to route_to('tickets#destroy', id: '1', building_id: "1" )
    end

    it 'routes to #open' do
      expect(put: '/buildings/1/tickets/1/open').to route_to('tickets#open', id: '1', building_id: "1" )
    end

    it 'routes to #close' do
      expect(put: '/buildings/1/tickets/1/close').to route_to('tickets#close', id: '1', building_id: "1" )
    end

    it 'routes to #escalate' do
      expect(put: '/buildings/1/tickets/1/escalate').to route_to('tickets#escalate', id: '1', building_id: "1" )
    end

    it 'routes to #de_escalate' do
      expect(put: '/buildings/1/tickets/1/deescalate').to route_to('tickets#deescalate', id: '1', building_id: "1" )
    end

  end
end
