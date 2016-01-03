require 'rails_helper'

RSpec.describe Api::PostsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: 'api/buildings/1/posts').to route_to('api/posts#index', building_id: "1" )
    end

    it 'routes to #show' do
      expect(get: 'api/buildings/1/posts/1').to route_to('api/posts#show', id: "1", building_id: "1" )
    end

    it 'routes to #tips' do
      expect(get: 'api/buildings/1/posts/tips').to route_to('api/posts#tips', building_id: "1" )
    end

  end
end
