require 'rails_helper'

RSpec.describe Activity, :type => :model do
   it  {should belong_to(:user) }
   it  {should belong_to(:building) }
   it  {should belong_to(:actionable) }
end
