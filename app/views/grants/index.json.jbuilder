json.array!(@grants) do |grant|
  json.extract! grant, :start_date, :end_date, :amount
  json.url grant_url(grant, format: :json)
end
