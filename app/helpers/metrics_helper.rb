module MetricsHelper
	#chart: Number and Secondary Stat
	def get_new_signup_data
		users = User.select("created_at, id").where(:created_at => 1.months.ago..Time.now)
    users_by_week = users.group_by{ |u| u.created_at.beginning_of_week }
    total_user_by_week = []
    total_amount = 0
    users_by_week.each do |week, users|
      total_user_by_week.push(users.count.to_s)
      total_amount = total_amount + users.count
    end

    data = { 
    	"item" => [
    		{
    			"text"  => "Past 1 month",
    		  "value" => total_amount.to_s
    		},
    		total_user_by_week
    	]
    }
    return data
	end

	#chart: Text
	def get_latest_recommendation_data
		latest_recommendation = Recommendation.last
		data = { 
			"item" => [
				{"text" => latest_recommendation.content},
				{"text" => latest_recommendation.user.full_name},
				{"text" => latest_recommendation.project.title},
				{"text" => project_url(latest_recommendation.project)}
			]
		}
	end

	#chart: Funnel Graph
	def get_donation_progress_data
		donation_progress = []
		donations = Donation.select("updated_at, amount, id").successful.where(:updated_at => 1.months.ago..Time.now).order(:updated_at)
		donations_by_week = donations.group_by{ |d| d.updated_at.beginning_of_week }
		count = 0
		prev_week_amount = 0

		donations_by_week.each do |key, donation|
			total_amount_by_week = 0			
			donation.each do |d|
				total_amount_by_week = total_amount_by_week + d.amount
			end
			total_amount_by_week = total_amount_by_week + prev_week_amount			
			count = count + 1
			prev_week_amount = total_amount_by_week
			donation_progress.push({:value => total_amount_by_week.to_s, :label => "Week #{count}"})
		end

		data = {
			"type" => "reverse", 
			"percentage" => "show", 
			"item" => donation_progress
		}
		return data
	end

	#chart: RAG numbers only
	def get_avg_collection_time_data
		donations = Donation.successful.select("created_at, updated_at")
		total_hours = 0
		donations.each do |donation|
			total_hours = total_hours + TimeDifference.between(donation.created_at, donation.updated_at).in_hours
		end
		avg_collection_time = total_hours / Donation.successful.count

		data = {
			"item" => [
				{
					"value" => Donation.count,
					"text"  => "Total donations"
				},
				{
					"value" => Donation.successful.count,
					"text"  => "Total successful donations"
				},
				{
					"value" => avg_collection_time,
					"text"  => "Average collection time (hrs)"
				}
			]
		}
		return data
	end

	#chart: RAG numbers only
	def get_avg_donation_amount_data
		avg_donation_amount = Donation.successful.sum(:amount) / Donation.successful.count

		data = {
			"item" => [
				{
					"value" => Donation.successful.sum(:amount),
					"text"  => "Total amount"
				},
				{
					"value" => Donation.successful.count,
					"text"  => "Total successful donations"
				},
				{
					"value" => avg_donation_amount,
					"text"  => "Average donation amount"
				}
			]
		}
		return data
	end
end