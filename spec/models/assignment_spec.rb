require 'rails_helper'
RSpec.describe Assignment, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:assignee) }
  it { should belong_to(:ticket) }
  it { should have_many(:comments) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:assignee) }
end
