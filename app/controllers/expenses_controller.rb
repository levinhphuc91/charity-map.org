class ExpensesController < InheritedResources::Base
  http_basic_authenticate_with name: ENV["HTTP_USERNAME"], password: ENV["HTTP_PASSWORD"]
end
