require 'rails_helper'

RSpec.describe VerificationRequestsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/verification_requests').to route_to('verification_requests#index')
    end

    it 'routes to #new' do
      expect(get: '/buildings/1/verification_requests/new').to route_to('verification_requests#new', building_id: '1')
    end

    it 'routes to #show' do
      expect(get: '/verification_requests/1').to route_to('verification_requests#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/verification_requests/1/edit').to route_to('verification_requests#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/buildings/1/verification_requests').to route_to('verification_requests#create', building_id: '1')
    end

    it 'routes to #update via PUT' do
      expect(put: '/verification_requests/1').to route_to('verification_requests#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/verification_requests/1').to route_to('verification_requests#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/verification_requests/1').to route_to('verification_requests#destroy', id: '1')
    end
  end
end
