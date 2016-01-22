require 'rails_helper'

RSpec.describe Api::UserController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: 'api/user/1').to route_to('api/user#show', id: '1')
    end
  end
end
