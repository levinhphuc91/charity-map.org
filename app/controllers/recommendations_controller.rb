class RecommendationsController < InheritedResources::Base
  before_filter :authenticate_user!, except: [:index, :show]

  def index
    render nothing: true
  end

  def new
    @project = Project.find(params[:project_id])
    new!
  end

  def create
    @project = Project.find(params[:project_id])
    @recommendation = Recommendation.new(params[:recommendation])
    if @recommendation.save
      respond_to do |format|
        format.json { render :json => @recommendation }
        format.html { redirect_to @project, notice: "Thank you. New recommendation has been added." }
      end
    else
      render :new, notice: "Unsuccessful. Try again"
    end
  end

end