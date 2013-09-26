class AdminMailer < ActionMailer::Base
  default from: "tu@charity-map.org"
  helper :application

  def new_pending_project(project)
    @project = project
    @user = @project.user
    mail(to: "team@charity-map.org", subject: "A project has just been submitted for review")
  end
end
