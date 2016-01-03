class TicketSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :building_id, :title, :body, :severity, :status, :created_at, :updated_at
end
