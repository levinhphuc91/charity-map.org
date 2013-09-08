namespace :donation do

  desc "reminders for bank-transfer donations"
  task :bank_transfer_donations_reminder => :environment do
  	three_days = Time.now.midnight - 3.days
  	seven_days = Time.now.midnight - 7.days
  	@donations = Donation.where("status = ? AND collection_method = ? AND ((created_at >= ? AND created_at <= ?) OR (created_at >= ? AND created_at <= ?))",
  		"PENDING", "BANK_TRANSFER", three_days.beginning_of_day, three_days.end_of_day, seven_days.beginning_of_day, seven_days.end_of_day)
  	@donations.each do |donation|
  		UserMailer.bank_transfer_donation_reminder(donation).deliver
  	end
  end
  # TODO: viet test

  desc "mark #failed for bank-transfer donations beyond 10 days"
  task :bank_transfer_mark_as_failed => :environment do
  	ten_days = Time.now.midnight - 10.days
  	@donations = Donation.where("status = ? AND collection_method = ? AND (created_at >= ? AND created_at <= ?)",
  		"PENDING", "BANK_TRANSFER", ten_days.beginning_of_day, ten_days.end_of_day)
  	@donations.each do |donation|
  		donation.update status: "FAILED"
  	end
  end
  # TODO: viet test
  
end