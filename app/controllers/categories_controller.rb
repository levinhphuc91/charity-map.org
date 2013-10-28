class CategoriesController < InheritedResources::Base
  before_filter :allow_staff_only, except: :index
  private
    def allow_staff_only
      redirect_to action: :index unless current_user && current_user.staff
    end
end
