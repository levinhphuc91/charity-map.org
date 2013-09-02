class ProjectsController < InheritedResources::Base
  before_filter :authenticate_user!, except: [:index, :show]

  def index
    @projects = Project.all
    # TODO: add model scope and limit displayed projects to only "reviewed"
  end

  def edit
    if current_user.projects.exists?(@project) != nil
      edit!
    else
      redirect_to :dashboard
      flash[:alert] = "Permission denied."
    end
    # TODO: test project edit without permission
  end
end
