class MetricsController < ApplicationController
  include MetricsHelper
  def new_signup
    data = get_new_signup_data()
    respond_to do |format|
      format.json { render :json => data }
    end
  end

  def latest_recommendation
    data = get_latest_recommendation_data()
    respond_to do |format|
      format.json { render :json => data }
    end
  end

  def donation_progress
    data = get_donation_progress_data()
    respond_to do |format|
      format.json { render :json => data }
    end
  end

  def avg_collection_time
    data = get_avg_collection_time_data()
    respond_to do |format|
      format.json { render :json => data }
    end
  end

  def avg_donation_amount
    data = get_avg_donation_amount_data()
    respond_to do |format|
      format.json { render :json => data }
    end
  end
end
