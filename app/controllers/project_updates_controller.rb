class ProjectUpdatesController < InheritedResources::Base

  def new
    @project = Project.find(params[:project_id])
    if (!signed_in?) || ((current_user) && (current_user.projects.exists?(@project) == nil))
      redirect_to @project, alert: "Permission denied."
    elsif @project.status == "FINISHED" || @project.status == "REVIEWED"
      new!
    else # outdated projects
      redirect_to edit_project_path(@project), alert: "Permission denied."
    end
  end

  def create
    @project = Project.find(params[:project_id])
    @project_update = ProjectUpdate.new(params[:project_update])
    if @project_update.save
      redirect_to edit_project_path(@project), notice: "Cập nhật vừa được thêm."
    else
      render :new, alert: "Không thành công. Vui lòng thử lại."
    end
  end
end
