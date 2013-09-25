class RecommendationsController < InheritedResources::Base
  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :limited_access, only: [:new, :create]
  include SessionsHelper
  # layout "layouts/dashboard"

  def index
    @project = Project.find(params[:project_id])
    @recommendations = @project.recommendations
    index!
  end

  def new
    @project = Project.find(params[:project_id])
    if current_user.verified?
      new!
    else
      store_location_with_path(new_project_recommendation_path(@project))
      redirect_to users_verify_path, alert: "Bạn phải tiến hành xác nhận danh tính (bằng số ĐT) trước khi viết giới thiệu cho dự án #{@project.title}."
    end
  end

  def create
    @project = Project.find(params[:project_id])
    @recommendation = Recommendation.new(params[:recommendation])
    if @recommendation.save
      respond_to do |format|
        format.json { render :json => @recommendation }
        format.html { redirect_to @project, notice: "Lời giới thiệu đã được lưu." }
      end
    else
      render :new, alert: "Không thành công. Vui lòng thử lại."
    end
  end

  private
    def limited_access
      @project = Project.find(params[:project_id])
      if @project.belongs_to?(current_user)
        redirect_to project_path(@project), alert: "Permission denied."
      end
    end

end
