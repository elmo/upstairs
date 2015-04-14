require 'rails_helper'

RSpec.describe Community, :type => :model do
    it { should have_many(:memberships) }
    it { should have_many(:users) }
    it { should validate_presense_of(:address_line_one) }
    it { should validate_presense_of(:city) }
    it { should validate_presense_of(:state) }
end
