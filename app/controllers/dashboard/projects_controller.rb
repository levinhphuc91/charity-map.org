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

  def members
    @managements = @project.managements
  end

  def add_member
    @user = User.find_by_email params[:email]
    if @user
      @management = @project.managements.create(user_id: @user.id)
      UserMailer.delay.add_member_to_project(@management) if params[:notification] == "true"
      redirect_to members_dashboard_project_path(@project), notice: "Thêm thành viên vào dự án thành công."
    else
      redirect_to members_dashboard_project_path(@project), alert: "Không tìm được tài khoản với email đã nhập."
    end
  end

  def remove_member
    @user = User.find params[:user_id]
    if @project.authorized_super_edit_for?(current_user) && @user
      @management = @project.managements.where(user_id: @user.id).first
      @project.managements.destroy(@management)
      redirect_to members_dashboard_project_path(@project), notice: "Xoá thành viên khỏi dự án thành công."
    else
      redirect_to members_dashboard_project_path(@project), alert: "Permission denied."
    end
  end

  private
    def restricted_access
      @project = Project.find(params[:id])
      unless @project.authorized_edit_for?(current_user)
        redirect_to :root, alert: "Permission denied."
      end
    end
end