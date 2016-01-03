require 'rails_helper'

RSpec.describe Api::EventsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: 'api/buildings/1/events').to route_to('api/events#index', building_id: "1" )
    end

    it 'routes to #show' do
      expect(get: 'api/buildings/1/events/1').to route_to('api/events#show', id: "1", building_id: "1" )
    end

  end
end
