include SessionsHelper

Then /^I should see page title as "(.*)"$/ do |title|
  expect(page).to have_title "#{title}"
end

Then /^I should( not)? see "([^"]*)" in the "([^"]*)" input$/ do |negate, content, labeltext|
  if negate
    expect(page).not_to have_field(labeltext, with: content)
  else
    expect(page).to have_field(labeltext, with: content)
  end
end

When /^a GET request is sent to "(.*?)"$/ do |url|
  visit url
end

When /^I get redirected via the last redirect token$/ do
  @token = RedirectToken.last
  visit redirect_via_token(@token)
end