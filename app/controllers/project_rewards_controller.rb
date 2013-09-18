class ProjectRewardsController < InheritedResources::Base 

  before_filter :authenticate_user!

  def index
    render nothing: true
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
        format.json { render :json => @project_reward }
        format.html { redirect_to edit_project_path(@project), notice: "Vừa thêm Đề mục đóng góp mới." }
      end
    else
      render :new, alert: "Không thành công. Vui lòng thử lại."
    end
  end
end
