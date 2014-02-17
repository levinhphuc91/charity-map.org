class AdminMailer < ActionMailer::Base
  default from: "tu@charity-map.org"
  helper :application
  layout "user_mailer"

  def new_pending_project(project)
    @project = project
    @user = @project.user
    mail(to: "team@charity-map.org", subject: "A project has just been submitted for review")
  end

  def daily_digest(users, projects, donations)
    @users, @projects, @donations = users, projects, donations
    mail(to: "team@charity-map.org", subject: "Daily Digest charity-map.org (#{Time.now.strftime("%d/%m/%Y")})")
  end
end