class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :memberships
  has_many :communities, through: :memberships
  has_many :activities

  has_paper_trail
  has_attachment :avatar, accept: [:jpg, :png, :gif]

  def join(community)
    self.memberships.create(community_id: community.id) unless member_of?(community)
  end

  def leave(community)
    memberships.where(community_id: community.id).destroy_all
  end

  def member_of?(community)
    memberships.where(community_id: community.id).exists?
  end

  def admin?
    true
  end

end
