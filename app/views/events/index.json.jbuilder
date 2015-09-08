json.array!(@events) do |event|
  json.extract! event, :id, :kind
  json.url event_url(event, format: :json)
end
