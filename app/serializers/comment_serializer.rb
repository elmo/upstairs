class CommentSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :parent_comment_id, :body, :flagged, :created_at, :updated_at, :replies_count
  has_many :replies

  def replies_count
    object.replies.count
  end
end
