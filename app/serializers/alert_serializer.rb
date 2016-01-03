class AlertSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :building_id, :message, :created_at, :updated_at
end
