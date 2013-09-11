class RecommendationsController < InheritedResources::Base
  before_filter :authenticate_user!, except: [:index, :show]

  def new
    @project = Project.find(params[:project_id])
    if current_user.verified?
      new!
    else
      redirect_to users_settings_path, alert: "Bạn phải tiến hành xác nhận danh tính (bằng số ĐT hoặc CMND) trước khi viết giới thiệu cho dự án #{@project.title}."
    end
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
