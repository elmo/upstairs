json.array!(@tenancies) do |tenancy|
  json.extract! tenancy, :id
  json.url tenancy_url(tenancy, format: :json)
end
