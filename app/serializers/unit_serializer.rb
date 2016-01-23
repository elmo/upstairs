class UnitSerializer < ActiveModel::Serializer
  attributes :id, :building_id, :name, :user_id
end
