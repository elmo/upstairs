class VerificationRequest < ActiveRecord::Base
  belongs_to :building
  belongs_to :user
  has_one :verification, dependent: :destroy
  validates_presence_of :user
  validates_presence_of :building
  validates_presence_of :status
  STATUS_PENDING = 'new'
  STATUS_APPROVED = 'approved'
  STATUS_REJECTED = 'rejected'
  STATUS_EXPIRED = 'expired'

  scope :approved, -> { where(status: STATUS_APPROVED) }
  scope :pending, -> { where(status: STATUS_PENDING) }
  scope :rejected, -> { where(status: STATUS_REJECTED) }
  scope :expired, -> { where(status: STATUS_EXPIRED) }

  def approve!
    update_column(:status, STATUS_APPROVED)
    notify_user_of_approval
  end

  def rejected!
    update_attributes(status: STATUS_REJECTED)
    notify_user_of_rejection
  end

  def expired!
    update_column(:status, STATUS_EXPIRED)
    notify_user_of_expiration
  end

  def approved?
    status == STATUS_APPROVED
  end

  def rejected?
    status == STATUS_REJECTED
  end

  def pending?
    status == STATUS_PENDING
  end

  def expired?
    status == STATUS_EXPIRED
  end

  def notify_user_of_approval
    UserMailer.verification_request_approved(self)
  end

  def notify_user_of_rejection
    UserMailer.verification_request_rejected(self)
  end

  def notify_user_of_expiration
    UserMailer.verification_expired(self)
  end
end
