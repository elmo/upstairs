class PostSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :category_id, :category_name, :title, :slug, :body, :flagged, :created_at, :updated_at, :comments_count
  has_many :comments

  def category_name
    object.category.name
  end

  def comments_count
    object.comments.count
  end
end
