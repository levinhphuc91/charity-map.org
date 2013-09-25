class ProjectUpdatesController < InheritedResources::Base

  before_filter :authenticate_user!, except: [:index, :show]
  layout "layouts/dashboard"

  def index
    @project = Project.find(params[:project_id])
    @project_updates = @project.project_updates
    index!
  end

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
      @project.project_follows.each do |pf|
        UserMailer.delay.send_updates_to_project_followers(@project_update, pf.user)
      end
      @project.donations.successful.each do |donation|
        UserMailer.delay.send_updates_to_project_followers(@project_update, donation.donor)
      end
      respond_to do |format|
        format.json { render :json => @project_update }
        format.html { redirect_to project_project_updates_path(@project), notice: "Vừa thêm Cập nhật dự án mới." }
      end
    else
      render :new, alert: "Không thành công. Vui lòng thử lại."
    end
  end
end
