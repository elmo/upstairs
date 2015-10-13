require 'rails_helper'

RSpec.describe InvitationsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/buildings/1/invitations').to route_to('invitations#index', building_id: '1')
    end

    it 'routes to #new' do
      expect(get: '/buildings/1/invitations/new').to route_to('invitations#new', building_id: '1')
    end

    it 'routes to #show' do
      expect(get: '/buildings/1/invitations/1').to route_to('invitations#show',  building_id: '1', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/buildings/1/invitations/1/edit').to route_to('invitations#edit', building_id: '1', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/buildings/1/invitations').to route_to('invitations#create', building_id: '1')
    end

    it 'routes to #update' do
      expect(put: '/buildings/1/invitations/1').to route_to('invitations#update',  building_id: '1', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/buildings/1/invitations/1').to route_to('invitations#destroy',  building_id: '1', id: '1')
    end
  end
end
