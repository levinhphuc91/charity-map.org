Then /^I should see page title as "(.*)"$/ do |title|
  expect(page).to have_title "#{title}"
end

Then /^I should see "([^"]*)" in the "([^"]*)" input$/ do |content, labeltext|
  expect(page).to have_field(labeltext, with: content)
end

When /^a GET request is sent to "(.*?)"$/ do |url|
  visit url
end