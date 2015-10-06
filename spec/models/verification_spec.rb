require 'rails_helper'

RSpec.describe Verification, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:building) }
  it { should belong_to(:verifier) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:building) }
  it { should validate_presence_of(:verifier) }
end
