class Dashboard::ProjectsController < InheritedResources::Base
  layout "layouts/dashboard"
  before_filter :authenticate_user!
  before_filter :restricted_access

  def index
    @projects = current_user.projects
    !index
  end

  def donations
  end

  private
    def restricted_access
      @project = Project.find_by_slug(params[:id])
      unless @project.belongs_to?(current_user)
        redirect_to :root, alert: "Permission denied."
      end
    end

end