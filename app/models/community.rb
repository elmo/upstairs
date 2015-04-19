class Community < ActiveRecord::Base
  has_many :memberships
  has_many :users, through: :memberships
  validates_presence_of :address_line_one
  validates_presence_of :city
  validates_presence_of :state
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged
  has_paper_trail

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
end
