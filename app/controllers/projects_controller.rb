class ProjectsController < InheritedResources::Base
  before_filter :authenticate_user!, except: [:index, :show]

  def edit
    if current_user.projects.exists?(@project)
      edit!
    else
      redirect_to :dashboard
      flash[:alert] = "Permission denied."
    end
    # TODO: test project edit without permission
  end
end
