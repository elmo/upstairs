require 'rails_helper'

RSpec.describe VerificationRequest, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:building) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:building) }
end
