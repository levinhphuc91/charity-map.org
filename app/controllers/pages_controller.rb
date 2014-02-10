class PagesController < ApplicationController
  def home
    @funding_projects = Project.funding
    @markers = Project.listed.mapped
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
end
