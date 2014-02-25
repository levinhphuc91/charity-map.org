class GoogleAnalyticsApi
  class << self

    def event(category, action, client_id = '555')
      return unless GOOGLE_ANALYTICS_SETTINGS[:tracking_code].present?

      params = {
        v: GOOGLE_ANALYTICS_SETTINGS[:version],
        tid: GOOGLE_ANALYTICS_SETTINGS[:tracking_code],
        cid: (Rails.env.test? ? '555' : client_id),
        t: 'event',
        ec: category,
        ea: action,
        ev: 1
      }

      begin
        RestClient.get(GOOGLE_ANALYTICS_SETTINGS[:endpoint], params: params, timeout: 4, open_timeout: 4)
        return true
      rescue  RestClient::Exception => rex
        return false
      end
    end

    handle_asynchronously :event

  end
end