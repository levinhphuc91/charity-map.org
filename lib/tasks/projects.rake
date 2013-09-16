namespace :project do
  desc "change project status after funding duration"
  task :change_project_status_to_finished_after_funding_dur => :environment do
    @projects = Project.where("end_date <= ?", Time.now.midnight)
    @projects.each do |project|
      project.update status: "FINISHED"
    end
    # TODO: write mailers
  end
end