class ProjectRewardsController < InheritedResources::Base 

  before_filter :authenticate_user!
  layout "layouts/dashboard"
  include DonationsHelper
  before_filter :limited_access, only: [:new, :create, :edit, :destroy]

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

  def edit
    @project = Project.find(params[:project_id])
    edit!
  end

  def destroy
    @project = Project.find(params[:project_id])
    super do |format|
      format.html { redirect_to project_project_rewards_path(@project), notice: "Xóa đề mục đóng góp thành công." }
    end
  end

  private
    def limited_access
      @project = Project.find(params[:project_id])
      unless @project.belongs_to?(current_user)
        redirect_to project_path(@project), alert: "Permission denied."
      end
    end
end
