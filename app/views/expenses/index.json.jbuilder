json.array!(@expenses) do |expense|
  json.extract! expense, :category, :amount, :project_id, :in_words
  json.url expense_url(expense, format: :json)
end
