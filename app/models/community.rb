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
  belongs_to :actionable, polymorphic: true
  validates_presence_of :address_line_one
  validates_presence_of :city
  validates_presence_of :state

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
    alerts.joins(:notifications)
     .where(["notifications.notifiable_type = 'Alert' and notifications.user_id = ? ", user.id] )
  end

end
