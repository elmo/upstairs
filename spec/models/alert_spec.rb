require 'rails_helper'

RSpec.describe Alert, :type => :model do
  it  {should belong_to(:user) }
  it  {should belong_to(:building) }
  it  {should have_many(:notifications) }
end
