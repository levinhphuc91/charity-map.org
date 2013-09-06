namespace :donation do
  desc "check donation and send request verification"
  task :send_request_verification => :environment do
  	three_days = Time.now.midnight - 3.day
  	seven_days = Time.now.midnight - 7.day
  	@donations = Donation.where("status = ? AND collection_method = ? AND ((created_at >= ? AND created_at <= ?) OR (created_at >= ? AND created_at <= ?))",
  															"PENDING", "BANK_TRANSFER", three_days.beginning_of_day, three_days.end_of_day, seven_days.beginning_of_day, seven_days.end_of_day)
  	@donations.each do |donation|
  		donation.update status: "REQUEST_VERIFICATION"
  		UserMailer.send_donation_remider(donation).deliver
  	end
  end
  desc "check 10-days-donation and mark it failed"
  task :mark_failed_donation => :environment do
  	ten_days = Time.now.midnight - 10.day
  	@donations = Donation.where("status = ? AND collection_method = ? AND (created_at >= ? AND created_at <= ?)",
  															"PENDING", "BANK_TRANSFER", ten_days.beginning_of_day, ten_days.end_of_day)
  	@donations.each do |donation|
  		donation.update status: "FAILED"
  	end
  end
end