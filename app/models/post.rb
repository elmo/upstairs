class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :postable, polymorphic: true
  has_many :comments, as: :commentable
  validates_presence_of :user
  has_paper_trail
end
