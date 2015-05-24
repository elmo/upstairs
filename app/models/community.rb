class Community < ActiveRecord::Base
  has_many :memberships
  has_many :users, through: :memberships
  has_many :posts, as: :postable
  has_many :comments, through: :posts
  has_many :activities
  has_many :alerts
  has_many :tickets
  has_many :classifieds
  has_many :notifications, through: :users
  has_many :invitations
  belongs_to :actionable, polymorphic: true
  validates_presence_of :address_line_one
  validates_presence_of :city
  validates_presence_of :state
  belongs_to :landlord, class_name: 'User', foreign_key: 'landlord_id'
  resourcify

  HOMEPAGE_WORD_MAX = 80

  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged
  has_paper_trail

  has_attachments :photos


  def slug_candidates
    [
      [:address_line_one, :city],
      [:address_line_one, :city, :state],
      [:address_line_one, :city, :state, :postal_code]
    ]
  end

  def membership(user)
    user.memberships.where(user_id: user.id).first
  end

  def public_name
    [name, address_line_one, address_line_two, city, state, postal_code].join(' ')
  end

  def alerts_for_user(user)
    alerts.recent.joins(:notifications)
     .where(["notifications.notifiable_id = alerts.id and notifications.notifiable_type = 'Alert' and notifications.user_id = ? ", user.id] )
  end

end
