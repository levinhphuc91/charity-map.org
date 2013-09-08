Given /^I am not authenticated$/ do
  visit('/users/sign_out')
end

Given /^I am a new, authenticated user$/ do
  email = 'testing@man.net'
  password = 'secretpass'
  full_name = 'charitymap'
  address = 'vietnam'
  User.new(:email => email, :password => password, :password_confirmation => password,
    :full_name => full_name, :address => address).save!

  visit '/users/sign_in'
  fill_in "user_email", :with => email
  fill_in "user_password", :with => password
  click_button "Sign in"
end

Given /^I login as "(.*?)"$/ do |email|
  password = 'secretpass'
  visit '/users/sign_in'
  fill_in "user_email", :with => email
  fill_in "user_password", :with => password
  click_button "Sign in"
end

Then(/^the URL should contain "(.*?)"$/) do |string|
  current_url.should include(string)
end