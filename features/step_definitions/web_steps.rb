Then /^I should see page title as "(.*)"$/ do |title|
  expect(page).to have_title "#{title}"
end