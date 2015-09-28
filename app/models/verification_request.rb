class VerificationRequest < ActiveRecord::Base
  belongs_to :building
  belongs_to :user
  validates_presence_of :user
  validates_presence_of :building
end
