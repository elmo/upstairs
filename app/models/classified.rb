class Classified < ActiveRecord::Base
   belongs_to :user
   belongs_to :community
   belongs_to :category
   validates_presence_of :category
   validates_presence_of :user
   validates_presence_of :community
   belongs_to :actionable, polymorphic: true
   has_many :notifications, as: :notifiable
   after_create :create_notifications
   after_create :create_actionable

   extend FriendlyId
   friendly_id :slug_candidates, use: :slugged
   has_paper_trail
   has_attachments :photos

  def slug_candidates
    [:title]
  end

  private

  def create_actionable
    Activity.create(actionable: self, user: self.user, community: self.community)
  end

  def create_notifications
    community(includes: :user).users.each { |member| Notification.create(notifiable: self, user: member)  }
  end

end
