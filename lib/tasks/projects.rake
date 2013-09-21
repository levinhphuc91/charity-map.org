namespace :project do
  desc "change project status after funding duration"
  task :change_project_status_to_finished_after_funding_dur => :environment do
    @projects = Project.where("end_date <= ?", Time.now.midnight)
    @projects.each do |project|
      project.update status: "FINISHED"
    end
    # TODO: write mailers
  end

  desc "remind those who follow project before 5 days"
  task :remind_followers_of_project_before_5_days => :environment do
  	five_days = Time.now.midnight - 5.days
  	@projects = Project.where("status = ? AND end_date >= ? AND end_date <= ?", "REVIEWED", five_days.beginning_of_day, five_days.end_of_day)
  	@projects.each do |project|
  		UserMailer.remind_follower_before_5_days(project).deliver
  	end
	end
end