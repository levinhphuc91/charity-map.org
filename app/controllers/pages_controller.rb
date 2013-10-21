class PagesController < ApplicationController
  def home
    @markers = Project.mapped
  end

  def about
  end

  def faqs
  end

  def guidelines
  end
end
