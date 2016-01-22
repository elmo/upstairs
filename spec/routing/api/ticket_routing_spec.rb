require 'rails_helper'

RSpec.describe Api::TicketsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: 'api/buildings/1/tickets').to route_to('api/tickets#index', building_id: '1')
    end

    it 'routes to #show' do
      expect(get: 'api/buildings/1/tickets/1').to route_to('api/tickets#show', id: '1', building_id: '1')
    end
  end
end
