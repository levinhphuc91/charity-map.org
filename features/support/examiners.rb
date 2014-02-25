# Define annotations to control cucumber scenario execution

# Wait for a key stroke after each step
Before '@api-call' do
  FakeWeb.clean_registry
  FakeWeb.allow_net_connect = %r[^https?://127.0.0.1]
  FakeWeb.register_uri(:get,
    %r|http://maps.googleapis\.com/|,
    :body => "Hello World!")
  FakeWeb.register_uri(:post, "https://staging-charitio.herokuapp.com/v1/users/create",
    :body => File.new("#{Rails.root}/features/support/json/create_user.json"),
    :content_type => 'application/json',
    :status => "201")
  FakeWeb.register_uri(:get, "https://staging-charitio.herokuapp.com/v1/transactions",
    :body => File.new("#{Rails.root}/features/support/json/get_transactions_not_found.json"),
    :content_type => 'application/json',
    :status => "400")
  FakeWeb.register_uri(:post, "https://staging-charitio.herokuapp.com/v1/transactions",
    :body => File.new("#{Rails.root}/features/support/json/create_transaction.json"),
    :content_type => 'application/json',
    :status => "201")
  FakeWeb.register_uri(:get, "https://staging-charitio.herokuapp.com/v1/users/balance",
    :body => File.new("#{Rails.root}/features/support/json/user_balance.json"),
    :content_type => 'application/json',
    :status => "200")
  FakeWeb.register_uri(:get, "https://staging-charitio.herokuapp.com/v1/users/show",
    :body => File.new("#{Rails.root}/features/support/json/create_user.json"),
    :content_type => 'application/json',
    :status => "200")
  FakeWeb.register_uri(:get, "https://staging-charitio.herokuapp.com/v1/users/update",
    :body => File.new("#{Rails.root}/features/support/json/update_user.json"),
    :content_type => 'application/json',
    :status => "200")
  FakeWeb.register_uri(:post, 'https://' + ENV['CAMPAIGN_MONITOR_API_KEY'] + ':x@api.createsend.com/api/v3/subscribers/76dc691d424ceab2f5d1ea2f68da79972.json',
    :body => File.new("#{Rails.root}/features/support/json/campaign_monitor_new_subscriber.json"),
    :content_type => 'application/json',
    :status => "200")
  FakeWeb.register_uri(:get, 'https://www.google-analytics.com/collect?v=1&tid=UA-32552864-2&cid=555&t=event&ec=SignUp&ea=Successful&ev=1',
    :status => "200")
end

Before '@step-through' do
  print "Hit a key after each step to continue"
end

AfterStep '@step-through' do
  print "hit enter"
  STDIN.getc
end

# Add a delay between @slo-mo scenarios
After '@slo-mo' do |scenario, block|
  sleep 10
end

# When running @slo-mo scenarios, wait a second after each step
AfterStep '@slo-mo' do |scenario|
  sleep 1
end


Before('@iphone') do
  Capybara.current_driver = :iphone
end

After('@iphone') do
  Capybara.use_default_driver
end

Before('@chrome') do
  Capybara.current_driver = :chrome
end

After('@chrome') do
  Capybara.use_default_driver
end

# Show the browser window whenever a step fails
After '@show-page-on-fail' do |scenario|
  if scenario.failed?
    print "Hit a key to continue"
    STDIN.getc
  end
end

After('@show-page') do |scenario|
  print "Finished - Press return to close browser (#{Time.now})"
  STDIN.getc
end

After('@reset_sessions') do |scenario|
  Capybara.reset_sessions!
end

After('@stay-open') do |scenario|
  print "Finished - Press return to close browser (#{Time.now})"
  STDIN.getc
end

Before('@enable-image-processing') do
  ImageUploader.enable_processing = true
end

After('@enable-image-processing') do |scenario|
  ImageUploader.enable_processing = false
end


When /^I open pry$/ do
  binding.pry
end

When /^let me see$/ do
  page.driver.debug
end

When /^take a picture$/ do
  page.driver.render('/tmp/file.png', :full => true)
end
