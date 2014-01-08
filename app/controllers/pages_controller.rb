class PagesController < ApplicationController
  def home
    @markers = Project.listed.mapped
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
