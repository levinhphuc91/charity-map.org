# submit ajax form without clicking button
Then /^I submit the "([^\"]*)" form$/ do |form_id|
    element = find_by_id(form_id)
    Capybara::RackTest::Form.new(page.driver, element.native).submit :name => nil
end