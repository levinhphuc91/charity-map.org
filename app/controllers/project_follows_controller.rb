class ProjectFollowsController < InheritedResources::Base
  actions :all, :except => [ :edit, :update, :destroy ]
  before_filter :authenticate_user!

  def initiate
    @project = Project.find(params[:project_id])
    @project_follow = @project.project_follows.build(user_id: current_user.id)
    if @project_follow.save
      respond_to do |format|
        format.js
        format.html { redirect_to project_path(@project), notice: t('controller.project_follows.register_successfully')}
      end
    else
      respond_to do |format|
        format.js
        format.html { redirect_to project_path(@project), alert: t('common.failed_and_try_again') }
      end
    end
  end
end
