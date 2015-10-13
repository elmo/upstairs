class Invitation < ActiveRecord::Base
  belongs_to :building
  belongs_to :user
  validates_presence_of :email
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, on: :create
  after_create :set_token
  after_create :send_invitation

  def to_param
    token
  end

  private

  def set_token
    update_attribute(:token, Digest::MD5.hexdigest("#{id}-#{email}"))
  end

  def send_invitation
    InvitationMailer.invite(self).deliver_now
  end
end
