class PagesController < ApplicationController
  def home
    @funding_projects = Project.funding
    @finished_projects = Project.finished
    @markers = Project.public_view.mapped
    render layout: "layouts/homepage"
  end

  def about
  end

  def faqs
  end

  def guidelines
  end

  def projects
  end

  def gifts
    @gift_card = GiftCard.find_by(token: params[:token]) if params[:token]
    render layout: "layouts/item-based"
  end
end
