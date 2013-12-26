class GrantsController < InheritedResources::Base
  def show
    @grant = Grant.find params[:id]
    @donations = Donation.successful.where("created_at >= ? AND created_at <= ?", @grant.start_date, @grant.end_date)
    @expenses = Expense.where("created_at >= ? AND created_at <= ?", @grant.start_date, @grant.end_date)
  end
end
