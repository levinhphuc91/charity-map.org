class Api::V1::ProjectsController < ApplicationController
  before_filter :http_authenticate, if: proc { Rails.env.production? }
  respond_to :json

  def index
    @projects = Project.public_view.limit(50)
  end

  protected

  def http_authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV["HTTP_USERNAME"] && password == ENV["HTTP_PASSWORD"]
    end
  end
end