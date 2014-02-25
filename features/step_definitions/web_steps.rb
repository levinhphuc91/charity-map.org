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

When /^I disable outgoing GA call$/ do
  FakeWeb.unregister_uri(:get, 'https://www.google-analytics.com/collect?v=1&tid=UA-32552864-2&cid=555&t=event&ec=SignUp&ea=Successful')
end

When /^I enable outgoing GA call$/ do
  FakeWeb.register_uri(:get, 'https://www.google-analytics.com/collect?v=1&tid=UA-32552864-2&cid=555&t=event&ec=SignUp&ea=Successful',
    status: 200)
end