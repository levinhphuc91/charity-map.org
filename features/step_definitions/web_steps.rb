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
  FakeWeb.unregister_uri(:get, 'https://www.google-analytics.com/collect?v=1&tid=UA-32552864-2&cid=555&t=event&ec=SignUp&ea=Successful&ev=1')
end

When /^I enable outgoing GA call$/ do
  FakeWeb.register_uri(:get, 'https://www.google-analytics.com/collect?v=1&tid=UA-32552864-2&cid=555&t=event&ec=SignUp&ea=Successful&ev=1',
    status: 200)
end

When /^I create an item based project named "(.+?)"$/ do |name|
  many_steps %{
    Given the date is 2013-09-10
    And there is a user with the email "fundraising@social.org" and the password "secretpass" and the password confirmation "secretpass" and the full name "Fundraising Organization" and the address "HCM" and the city "HCM" and the phone "123456789"
    When I login as "fundraising@social.org"
    And I go to the new project page
    And I fill in "project_title" with "#{name}"
    And I fill in "project_brief" with "This is a short brief"
    And I fill in "project_description" with "Here comes a description"
    And I check "project_item_based"
    And I fill in "project_start_date" with "10/09/2013"
    And I fill in "project_end_date" with "24/09/2013"
    And I fill in "project_funding_goal" with "9999999"
    And I fill in "project_location" with "227 Nguyen Van Cu"
    And I check "project[terms_of_service]"
    And I press "Lưu"
  }
  Project.last.update_attribute(:unlisted, false)
end

When /^I start fundraising for project "(.+?)"$/ do |name|
  many_steps %{
    When I go to the project page of "#{name}"
    When I follow "Tiến Hành Gây Quỹ"
      And I fill in "project_reward_name" with "Reward Dau Tien"
      And I fill in "project_reward_value" with "75000"
      And I fill in "project_reward_quantity" with "10"
      And I fill in "project_reward_description" with "Nothing extra."
      And I press "Lưu"
      And I fill in "project_reward_name" with "Reward Thu Hai"
      And I fill in "project_reward_value" with "150000"
      And I fill in "project_reward_quantity" with "10"
      And I fill in "project_reward_description" with "Nothing extra."
      And I press "Lưu"
    When I go to the project page of "Push The World"
      And I follow "Tiến Hành Gây Quỹ"
  }
end

When /^"(.*)" receives a credit of "(.*)"$/ do |email, amount|
  many_steps %{
    Given there is a user with the email "mixup@gmail.com" and the password "secretpass" and the password confirmation "secretpass"
    And I am not authenticated
      And I login as "mixup@gmail.com"
      And I go to the gift cards dashboard
      And I follow "+ Tạo gift card"
      And I fill in "gift_card_recipient_email" with "#{email}"
      And I fill in "gift_card_amount" with "#{amount}"
      And I fill in "gift_card_references_recipient_name" with "#{email}"
      And I check "communication"
      And I press "submit"
    And "#{email}" should receive an email
    When I open the email
    And I am not authenticated
    When I follow "đường dẫn này" in the email
      And I press "Bắt đầu sử dụng thẻ"
      And I fill in "user_email" with "#{email}"
      And I fill in "user_password" with "secretpass"
      And I fill in "user_password_confirmation" with "secretpass"
      And I press "Đăng Ký"
  }
end

When /^I complete my profile update$/ do
  many_steps %{
    And I fill in "user_full_name" with "Nguoi Ung Ho"
    And I fill in "user_address" with "Ho Chi Minh"
    And I fill in "user_phone" with "0903011591"
    And I press "Cập nhật Thông Tin"
  }
end

When /^I run the background jobs$/ do
  Delayed::Worker.new.work_off
end

When /^I list out a project named "(.+?)"$/ do |name|
  Project.find_by_title(name).update_attribute :unlisted, false
end