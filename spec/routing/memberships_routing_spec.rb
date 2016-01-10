require 'rails_helper'

RSpec.describe MembershipsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/buildings/1/memberships').to route_to('memberships#index', building_id: "1" )
    end

    it 'routes to #create' do
      expect(post: '/buildings/1/memberships').to route_to('memberships#create', building_id: "1" )
    end

    it 'routes to #destroy' do
      expect(delete: '/buildings/1/memberships/1').to route_to('memberships#destroy', id: '1', building_id: "1" )
    end

    it 'routes to #grant' do
      expect(put: '/buildings/1/memberships/1/grant').to route_to('memberships#grant', id: '1', building_id: "1" )
    end

    it 'routes to #revoke' do
      expect(put: '/buildings/1/memberships/1/revoke').to route_to('memberships#revoke', id: '1', building_id: "1" )
    end

  end
end
