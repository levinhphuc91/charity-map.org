require 'createsend'

module Monitored
  extend ActiveSupport::Concern

  included do
    after_create :add_new_subscriber_to_list
  end

  def add_new_subscriber_to_list
    auth = {api_key: ENV['CAMPAIGN_MONITOR_API_KEY']}
    begin
      CreateSend::Subscriber.add auth, '76dc691d424ceab2f5d1ea2f68da79972', self.email, '', [], true
    rescue CreateSend::BadRequest => br
      @message = %Q{\
        [#{Time.zone.now}][User#add_new_subscriber_to_list] \n \
        Affected user: #{self.try(:id)} \n \
        API response: #{br}}
      AdminMailer.delay.report_error('User#add_new_subscriber_to_list', @message)
    end
  end

  handle_asynchronously :add_new_subscriber_to_list
end