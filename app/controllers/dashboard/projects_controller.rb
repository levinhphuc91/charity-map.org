class Dashboard::ProjectsController < InheritedResources::Base

  layout "layouts/dashboard"

  def index
    @projects = current_user.projects
    !index
  end

  def donations
  end

end