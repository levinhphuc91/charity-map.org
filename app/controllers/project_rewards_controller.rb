class ProjectRewardsController < InheritedResources::Base 

  before_filter :authenticate_user!
  layout "layouts/dashboard"
  include DonationsHelper

  def index
    @project = Project.find(params[:project_id])
    @project_rewards = @project.project_rewards
    @reward_popularity = reward_popularity(@project)
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
      redirect_to project_project_rewards_path(@project), alert: "Lỗi: #{@project_reward.errors.full_messages.join(", ")}"
    end
  end
end
