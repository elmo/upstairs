class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :postable, polymorphic: true
  has_many :comments, as: :commentable
  has_many :notifications, as: :notifiable
  validates_presence_of :user
  validates_presence_of :title
  after_create :create_notifications

  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  has_paper_trail

  def commenters
    comments.collect(&:user).uniq
  end

  def create_notifications
    postable(includes: :user).users.each { |member| Notification.create(notifiable: self, user: member)  }
  end

  def slug_candidates
    [ :title ]
  end

  def verb
    " posted "
  end

  def grandparent
   self
  end

  def name
    title
  end

end
