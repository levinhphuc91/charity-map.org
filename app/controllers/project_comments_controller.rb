class ProjectCommentsController < InheritedResources::Base
  nested_belongs_to :project
  before_filter :authenticate_user!, except: [:index, :show]
  layout "layouts/item-based", only: [:index]

  def index
    @new_comment = ProjectComment.new
    index!
  end

  def create
    @project = Project.find(params[:project_id])
    @project_comment = ProjectComment.new(params[:project_comment])
    if @project_comment.save
      respond_to do |format|
        format.html { redirect_to project_project_comments_path(@project), notice: "Bình luận vừa được thêm." }
      end
    else
      render :new, alert: t('common.failed_and_try_again')
    end
  end
end