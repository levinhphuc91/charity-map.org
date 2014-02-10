class PagesController < ApplicationController
  def home
    @funding_projects = Project.funding
    @finished_projects = Project.finished
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
