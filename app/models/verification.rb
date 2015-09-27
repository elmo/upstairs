class Verification < ActiveRecord::Base
  belongs_to :user
  belongs_to :building
  belongs_to :verifier, class_name: 'User', foreign_key: 'verifier_id'
  validates_presence_of :user
  validates_presence_of :building
  validates_presence_of :verifier
end
