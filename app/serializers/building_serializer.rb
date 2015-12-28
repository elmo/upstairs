class BuildingSerializer < ActiveModel::Serializer
  attributes :id, :name, :address, :invitation_link, :latitude, :float, :longitude, :active, :created_at, :updated_at, :slug
end
