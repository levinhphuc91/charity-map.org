json.array!(@gift_cards) do |gift_card|
  json.extract! gift_card, :id, :recipient_email, :amount, :references
  json.url gift_card_url(gift_card, format: :json)
end
