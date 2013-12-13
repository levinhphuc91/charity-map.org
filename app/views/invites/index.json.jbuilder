json.array!(@invites) do |invite|
  json.extract! invite, :name, :email, :phone
  json.url invite_url(invite, format: :json)
end
