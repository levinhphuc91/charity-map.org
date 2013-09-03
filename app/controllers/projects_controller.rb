class ProjectsController < InheritedResources::Base
  before_filter :authenticate_user!, except: [:index, :show]

  def index
    if params[:filter] && params[:filter] == "funding"
      @projects = Project.funding
    elsif params[:filter] == "finished"
      @projects = Project.finished
    else
      @projects = Project.public_view
    end
  end

  # TODO: conditional :show for DRAFT,Pending,  REVIEWED and FINISHED projects

  def edit
    if current_user.projects.exists?(@project) != nil
      edit!
    else
      redirect_to :dashboard
      flash[:alert] = "Permission denied."
    end
    # TODO: test project edit without permission
  end

  def to_param
    # [id, title.parameterize].join("-")
    [title, id.parameterize].join("-")
  end

  def submit
    @project = Project.find(params[:id])
    if current_user && current_user.projects.exists?(@project) && @project.status == "DRAFT"
      @project.update status: "PENDING"
      redirect_to @project
      flash[:notice] = "Project has been submitted. We'll keel you in touch."
    else
      flash[:notice] = "Permission denid"
      redirect_to :dashboard
    end
  end
  # TODO: viet test
end
