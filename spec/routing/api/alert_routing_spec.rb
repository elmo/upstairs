require 'rails_helper'

RSpec.describe Api::AlertsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: 'api/buildings/1/alerts').to route_to('api/alerts#index', building_id: '1')
    end

    it 'routes to #show' do
      expect(get: 'api/buildings/1/alerts/1').to route_to('api/alerts#show', id: '1', building_id: '1')
    end
  end
end
