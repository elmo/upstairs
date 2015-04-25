class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :community
  belongs_to :actionable, polymorphic: true
end
