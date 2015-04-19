class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  has_many :replies, class_name: 'Comment', foreign_key: "parent_comment_id"
  validates_presence_of :user
  belongs_to :comment, foreign_key: "parent_comment_id"
  has_paper_trail

  def grandparent
    (parent_comment_id.present?) ? comment.commentable : commentable
  end
end
