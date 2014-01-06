class ProjectFollowsController < InheritedResources::Base
  actions :all, :except => [ :edit, :update, :destroy ]
  before_filter :authenticate_user!

  def initiate
    @project = Project.find(params[:project_id])
    @project_follow = @project.project_follows.build(user_id: current_user.id)
    if @project_follow.save
      respond_to do |format|
        format.js
        format.html { redirect_to project_path(@project), notice: "Đăng ký nhận cập nhật từ dự án thành công." }
      end
    else
      respond_to do |format|
        format.js
        format.html { redirect_to project_path(@project), alert: "Không thành công. Vui lòng thử lại." }
      end
    end
  end
end
