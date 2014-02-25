Airbrake.configure do |config|
  config.api_key = '1e174eacbca243182166bf730197db73'
  config.user_attributes = [:id]
  config.rescue_rake_exceptions = true
  config.async do |notice|
    Airbrake.sender.delay.send_to_airbrake(notice.to_xml)
  end
end