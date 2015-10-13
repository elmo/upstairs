class Verification < ActiveRecord::Base
  belongs_to :user
  belongs_to :building
  belongs_to :verifier, class_name: 'User', foreign_key: 'verifier_id'
  belongs_to :verification_request
  validates_presence_of :user
  validates_presence_of :building
  validates_presence_of :verifier
  validates_presence_of :verification_request
  after_save :approve_request
  before_destroy :expire_request

  def approve_request
    verification_request.approve!
  end

  def expire_request
    verification_request.expired!
  end
end
