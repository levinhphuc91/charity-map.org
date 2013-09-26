class MetricsController < ApplicationController
  def new_signup
    data = { "item" => "23",
      "max" => {
        "text" => "Max value",
        "value" => "30"
      },
      "min" => {
        "text" => "Min value",
        "value" => "10"
      }
    }

    { 
    respond_to do |format|
      format.json { render :json => data }
    end
  end

  def donation_progress
  end
end
