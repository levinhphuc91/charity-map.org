class CategoriesController < InheritedResources::Base
  actions :all, :except => [ :new, :create, :edit, :update, :destroy ]
  before_filter :allow_staff_only, except: [ :index, :show ]

  def index
    @categories = Category.all
    @projects = Project.public_view
  end

  def show
    show!
    @projects = @category.projects
  end

  private
    def allow_staff_only
      redirect_to action: :index unless current_user && current_user.staff
    end
end
