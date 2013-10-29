class ProjectCommentsController < InheritedResources::Base

  before_filter :authenticate_user!, except: [:index, :show]

  def create
    @project = Project.find_by_slug(params[:project_id])
    @project_comment = ProjectComment.new(params[:project_comment])
    if @project_comment.save
      respond_to do |format|
        format.html { redirect_to project_path(@project), notice: "Bình luận vừa được thêm." }
      end
    else
      render :new, alert: "Không thành công. Vui lòng thử lại."
    end
  end
end
