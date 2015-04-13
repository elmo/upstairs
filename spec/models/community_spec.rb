require 'rails_helper'

RSpec.describe Community, :type => :model do
    it { should have_many(:memberships) }
    it { should have_many(:users) }
end
