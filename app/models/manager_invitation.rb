class ManagerInvitation < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user
  validates_presence_of :email
  validates_format_of :email, with: Devise::email_regexp
  after_create :process_invitation

  STATUS_NEW = 'new'
  STATUS_PENDING = 'pending'
  STATUS_RESENT= 'resent'
  STATUS_CLOSED = 'closed'


  scope :closed, -> { where(status: STATUS_CLOSED) }
  scope :open, -> { where(status: STATUS_NEW) }
  scope :pending, -> { where(status: STATUS_PENDING) }

  def close!
    update_attributes(status: STATUS_CLOSED )
  end

  def closed?
    status == STATUS_CLOSED
  end

  def open!
    update_attributes(status: STATUS_NEW)
  end

  def open?
    status == STATUS_NEW
  end

  def pending!
    update_attributes(status: STATUS_PENDING)
  end

  def pending?
    status == STATUS_PENDING
  end

  def resent!
    update_attributes(status: STATUS_RESENT)
  end

  def resent?
    status == STATUS_RESENT
  end

  def self.statuses
    [STATUS_NEW, STATUS_PENDING, STATUS_CLOSED]
  end

  def resend
    pending!
    ManagerInvitationMailer.invite(email: email)
  end

  def process_invitation
    manager_user = User.find_by_email(email)
    if manager_user.present?
      closed!
    else
      manager_user = create_user_with_temporary_password
      ManagerInvitationMailer.invite(email: email)
      pending!
    end
    make_manager_of_all_user_properities(manager_user)
  end

  private

  def create_user_with_temporary_password
    temporary_password = SecureRandom.hex(4)
    User.create(email: email, password: temporary_password, password_confirmation: temporary_password)
  end

  def make_manager_of_all_user_properities(manager_user:)
    manager_user.owned_properties.each { |building| manager_user.make_manager(building) }
  end

end
