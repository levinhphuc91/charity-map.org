class ProjectRewardsController < InheritedResources::Base 
  nested_belongs_to :project
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
    create! do |success, failure|
      success.html { redirect_to project_project_rewards_path(@project), notice: t('controller.project_rewards.create_successfully') }
      failure.html { redirect_to project_project_rewards_path(@project), alert: "Lỗi: #{@project_reward.errors.full_messages.join(', ')}" }
    end
  end

  def update
    update! { project_project_rewards_path(@project) }
  end

  def destroy
    @project = Project.find(params[:project_id])
    super do |format|
      format.html { redirect_to project_project_rewards_path(@project), notice: t('controller.project_rewards.delete_successfully') }
    end
  end

  private
    def limited_access
      @project = Project.find(params[:project_id])
      unless @project.belongs_to?(current_user)
        redirect_to project_path(@project), alert: t('common.permission_denied')
      end
    end
end
