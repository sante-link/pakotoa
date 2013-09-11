json.array!(@authorities) do |authority|
  json.extract! authority, :name
  json.url authority_url(authority, format: :json)
end
