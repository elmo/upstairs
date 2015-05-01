class Classified < ActiveRecord::Base
   belongs_to :user
   belongs_to :community
   belongs_to :category
   validates_presence_of :category
   validates_presence_of :user
   validates_presence_of :community

   extend FriendlyId
   friendly_id :slug_candidates, use: :slugged
   has_paper_trail
   has_attachments :photos

  def slug_candidates
    [:title]
  end

end
