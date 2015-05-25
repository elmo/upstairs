require 'rails_helper'

RSpec.describe Community, :type => :model do
    it { should have_many(:memberships) }
    it { should have_many(:users) }
    it { should have_many(:posts) }
    it { should have_many(:comments) }
    it { should validate_presence_of(:address) }
end
