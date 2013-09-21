class ProjectFollowsController < InheritedResources::Base

  before_filter :authenticate_user!

  def create
    @project_follow = ProjectFollow.new(params[:project_follow])
    if @project_follow.save
      respond_to do |format|
        format.json { render :json => @project_follow }
        format.html { redirect_to project_path(@project), notice: "Bình luận vừa được thêm." }
      end
    else
      render :new, alert: "Không thành công. Vui lòng thử lại."
    end
  end

end
