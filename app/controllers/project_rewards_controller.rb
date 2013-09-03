class ProjectRewardsController < InheritedResources::Base
  def index
    render nothing: true
  end

  def new
    @project = Project.find(params[:project_id])
    new!
  end

  def create
    @project = Project.find(params[:project_reward][:project_id])
    puts params[:project_reward]
    @project_reward = ProjectReward.new(params[:project_reward])
    if @project_reward.save
      redirect_to edit_project_path(@project)
      flash[:notice] = "New reward has been added"
    else
      render :new
      flash[:notice] = "Unsuccessful. Try again"
    end
  end
end
