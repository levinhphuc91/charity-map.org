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
        format.html { redirect_to edit_project_path(@project), notice: "New reward has been added" }
      end
    else
      render :new, notice: "Unsuccessful. Try again"
    end
  end
end
