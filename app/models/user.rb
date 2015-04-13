class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :memberships
  has_many :communities, through: :memberships


  def join(community)
    self.memberships.create(community_id: community.id) if !memberships.where(community_id: community.id).exists?
  end

  def leave(community)
    memberships.where(community_id: community.id).destroy_all
  end

end
