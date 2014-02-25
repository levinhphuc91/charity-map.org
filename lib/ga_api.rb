require 'rest_client'
class GoogleAnalyticsApi
  class << self

    def event(category, action, client_id = '555')
      params = {
        v: 1,
        tid: 'UA-32552864-2',
        cid: (Rails.env.test? ? '555' : client_id),
        t: 'event',
        ec: category,
        ea: action,
        ev: 1
      }

      begin
        RestClient.get('http://www.google-analytics.com/collect', params: params, timeout: 4, open_timeout: 4)
        return true
      rescue  RestClient::Exception => rex
        return false
      end
    end

    handle_asynchronously :event

  end
end