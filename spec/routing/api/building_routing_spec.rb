require 'rails_helper'

RSpec.describe Api::BuildingsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: 'api/buildings/1').to route_to('api/buildings#show', id: '1')
    end
  end
end
