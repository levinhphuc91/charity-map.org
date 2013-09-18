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
        format.html { redirect_to @project, notice: "Lời giới thiệu đã được lưu." }
      end
    else
      render :new, alert: "Không thành công. Vui lòng thử lại."
    end
  end

end
