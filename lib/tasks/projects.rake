namespace :projects do
  desc "change project status after funding duration"
  task :change_status_to_finished_after_end_date => :environment do
    @projects = Project.where("end_date <= ?", Time.now.midnight)
    @projects.each do |project|
      project.update status: "FINISHED"
    end
    # TODO: write mailers
  end

  # IMPORTANT: run this once a day
  # TODO: write tests
  desc "remind project followers 5 days before project end_date"
  task :remind_project_followers_5_days_before_end_date => :environment do
  	five_days = Time.now.midnight + 5.days
  	@projects = Project.where("status = ? AND end_date >= ? AND end_date <= ?", "REVIEWED", five_days.beginning_of_day, five_days.end_of_day)
  	@projects.each do |project|
      project.project_follows.each do |pf|
        follower = pf.user
    		UserMailer.delay.remind_followers_5_days_before_end_date(project, follower)
      end
  	end
	end
end