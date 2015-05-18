class Invitation < ActiveRecord::Base
  belongs_to :community
  belongs_to :user
  validates_presence_of :email
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create

  after_create :set_token

  def to_param
    token
  end

  private

  def set_token
    update_attribute(:token, Digest::MD5.hexdigest("#{id}-#{email}") )
  end

end
