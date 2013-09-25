class ProjectRewardsController < InheritedResources::Base 

  before_filter :authenticate_user!
  layout "layouts/dashboard"

  def index
    @project = Project.find(params[:project_id])
    @project_reward = ProjectReward.new
    index!
  end

  def new
    @project = Project.find(params[:project_id])
    new!
  end

  def create
    @project = Project.find(params[:project_id])
    @project_reward = ProjectReward.new(params[:project_reward])
    if @project_reward.save
      respond_to do |format|
        format.js
        # format.json { render :json => @project_reward }
        format.html { redirect_to project_project_rewards_path(@project), notice: "Vừa thêm Đề mục đóng góp mới." }
      end
    else
      render :new, alert: "Không thành công. Vui lòng thử lại."
    end
  end
end
