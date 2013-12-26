class GrantsController < InheritedResources::Base
  http_basic_authenticate_with name: ENV["HTTP_USERNAME"], password: ENV["HTTP_PASSWORD"], except: [:index, :show]

  def show
    @grant = Grant.find params[:id]
    @donations = Donation.successful.where("created_at >= ? AND created_at <= ?", @grant.start_date, @grant.end_date)
    @expenses = Expense.where("created_at >= ? AND created_at <= ?", @grant.start_date, @grant.end_date)
  end
end
