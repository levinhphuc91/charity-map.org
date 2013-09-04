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
    @pending = Project.pending
  end

  def new
    @project = Project.new
    if current_user.full_name.blank? || current_user.address.blank?
      redirect_to users_settings_path, notice: "Vui lòng cập nhật tên họ và địa chỉ trước khi tạo dự án."
    end
  end

  def show
    @project = Project.find(params[:id])
    if @project.status == "DRAFT" || @project.status == "PENDING"
      if (!signed_in?) || ((current_user) && (current_user.projects.exists?(@project) == nil) && (!current_user.staff))
        redirect_to pages_home_path, alert: "Permission denied."
      end
    end
  end

  def edit
    @project = Project.find(params[:id])
    if (current_user.projects.exists?(@project) != nil)
      edit!
    else
      redirect_to :dashboard, alert: "Permission denied."
    end
  end

  def to_param
    # [id, title.parameterize].join("-")
    [title, id.parameterize].join("-")
  end

  def submit
    @project = Project.find(params[:id])
    if current_user && current_user.projects.exists?(@project) && @project.status == "DRAFT"
      if @project.project_rewards.empty?
        redirect_to edit_project_path(@project), notice: "Please have at least one reward."
      else
        if @project.update status: "PENDING"
          redirect_to @project, notice: "Project has been submitted. We'll keel you in touch."
        else
          redirect_to edit_project_path(@project), notice: "#{@project.errors.full_messages.join(' ')}"
        end
      end
    else
      redirect_to :dashboard, notice: "Permission denied"
    end
  end
end
