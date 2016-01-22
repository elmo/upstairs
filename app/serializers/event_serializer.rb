class EventSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :starts, :building_id, :user_id, :created_at, :updated_at, :comments_count, :building
  has_many :comments

  def comments_count
    object.comments.count
  end

  def building
    object.building
  end
end
