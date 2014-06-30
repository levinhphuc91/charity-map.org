require 'createsend'

module Monitored
  extend ActiveSupport::Concern

  included do
    after_create :add_new_subscriber_to_list
  end

  def add_new_subscriber_to_list
    auth = {api_key: ENV['CAMPAIGN_MONITOR_API_KEY']}
    begin
      CreateSend::Subscriber.add auth, '2b0bc2d32f4bab37be1dcdf67fed88e6', self.email, '', [], true
    rescue CreateSend::BadRequest => br
      Honeybadger.notify(br)
    end
  end

  handle_asynchronously :add_new_subscriber_to_list
end