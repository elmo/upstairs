json.array!(@units) do |unit|
  json.extract! unit, :id, :building_id, :name, :user_id
  json.url unit_url(unit, format: :json)
end
