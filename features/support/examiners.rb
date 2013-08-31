# Define annotations to control cucumber scenario execution

# Wait for a key stroke after each step
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
