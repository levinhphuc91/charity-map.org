namespace :donations do

  desc "reminders for bank-transfer donations"
  task :bank_transfer_reminder => :environment do
  	five_days = Time.now.midnight - 5.days
  	ten_days = Time.now.midnight - 10.days
  	@donations = Donation.where("status = ? AND collection_method = ? AND ((created_at >= ? AND created_at <= ?) OR (created_at >= ? AND created_at <= ?))",
  		"PENDING", "BANK_TRANSFER", five_days.beginning_of_day, five_days.end_of_day, ten_days.beginning_of_day, ten_days.end_of_day)
    if @donations
    	@donations.each do |donation|
        begin
          UserMailer.bank_transfer_donation_reminder(donation).deliver
        rescue Exception => e
          Airbrake.notify(e)
        end
    	end
    end
  end

  desc "mark #failed for bank-transfer donations beyond 15 days"
  task :bank_transfer_mark_as_failed => :environment do
  	fiften_days = Time.now.midnight - 15.days
  	@donations = Donation.where("status = ? AND collection_method = ? AND created_at <= ?", "PENDING", "BANK_TRANSFER", fiften_days)
  	@donations.each do |donation|
      begin
        donation.update_attribute :status, "FAILED" if donation.status != "FAILED"
      rescue Exception => e
        Airbrake.notify(e)
      end
  	end
  end  
end