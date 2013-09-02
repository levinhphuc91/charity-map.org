class ProjectsController < InheritedResources::Base
  before_filter :authenticate_user!, except: [:index, :show]

  def index
    if params[:filter] && params[:filter] == "FUNDING"
      @projects = Project.funding
    elsif params[:filter] == "FINISHED"
      @projects = Project.finished
    else
      @projects = Project.public_view
    end
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
