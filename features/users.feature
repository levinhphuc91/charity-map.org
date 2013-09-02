Feature: User
  Scenario: Update their profile settings
    Given I am a new, authenticated user
      And I am on the users settings page
      And I fill in "Email" with "saidrebyn@gmail.com"
      And I fill in "Full name" with "Hoang Minh Tu"
      And I fill in "Address" with "10.5B D5 Binh Thanh"
      And I select "Ho Chi Minh" from "City"
      And I fill in "Bio" with "Charity Map co-founders"
      And I fill in "Phone" with "0908 230 591"
      And I press "Update"
    Then I should see "Updated Successfully."

  Scenario: Visit dashboard, as a backer, without donations 
    Given I am a new, authenticated user
    When I go to the dashboard
    Then I should see "Hiện chưa có thống kê về những khoản tài trợ bạn đã đóng góp."

  Scenario: Visit dashboard, as a backer having donations 
    Given there is a user with the email "vumanhcuong01@gmail.com" and the id "1" and the password "12345678" and the password confirmation "12345678"
      And there is a project with the id "1" title "Books from Heart" and the description "Giving away libraries for suburban schools." and the start date "2013-05-23" and the end date "2013-05-30" and the funding goal "5000000" and the location "Ho Chi Minh City" and the user id "1"
      And there is a donation with the user id "1" and the project id "1" and the amount "500000" and the collection method "COD"
    When I go to the login page
      And I fill in "Email" with "vumanhcuong01@gmail.com"
      And I fill in "Password" with "12345678"
      And I press "Sign in"
    When I go to the dashboard
    
    Then I should see "500.000"
      And I should see "COD"

  Scenario: Visit dashboard, as a project creator
    Given there is a user with the email "vumanhcuong01@gmail.com" and the id "1" and the password "12345678" and the password confirmation "12345678"
      And there is a donation with the user id "2" and the amount "250000" and the collection method "COD" and the project id "1"
      And there is a donation with the user id "3" and the amount "250000" and the collection method "COD" and the project id "1"
      Given there is a project with the title "Books from Heart" and the description "Giving away libraries for suburban schools." and the start date "2013-05-23" and the end date "2013-05-30" and the funding goal "5000000" and the location "Ho Chi Minh City" and the user id "1"
    When I go to the login page
      And I fill in "Email" with "vumanhcuong01@gmail.com"
      And I fill in "Password" with "12345678"
      And I press "Sign in"
    When I go to the dashboard
    Then I should see "Books from Heart"
      And I should see "5.000.000"
      # TODO: revise test to test more precise info

  Scenario: Sign in Charity Map successfully
    Given there is a user with the email "vumanhcuong01@gmail.com" and the id "1" and the password "12345678" and the password confirmation "12345678"
    When I go to the login page
      And I fill in "Email" with "vumanhcuong01@gmail.com"
      And I fill in "Password" with "12345678"
      And I press "Sign in" 
    Then I should see "Đăng nhập thành công."

  Scenario: Sign in Charity Map with invalid email & password
    Given there is a user with the email "vumanhcuong01@gmail.com" and the id "1" and the password "12345678" and the password confirmation "12345678"
    When I go to the login page
      And I fill in "Email" with "vumanhcuon@gmail.com"
      And I fill in "Password" with "12345"
      And I press "Sign in" 
    Then I should see "Email hoặc mật khẩu không chính xác."

  Scenario: Sign up successfully
    When I go to the signup page
      And I fill in "Email" with "vumanhcuong0103@gmail.com"
      And I fill in "user_password" with "12345678"
      And I fill in "Password confirmation" with "12345678"
      And I press "Sign up"
    Then I should see "Xin chào! Bạn đã đăng ký thành công."
  
  Scenario: Sign up with existing email 
    Given there is a user with the email "vumanhcuong01@gmail.com" and the id "1" and the password "12345678" and the password confirmation "12345678"
    When I go to the signup page
      And I fill in "Email" with "vumanhcuong01@gmail.com"
      And I fill in "user_password" with "12345678"
      And I fill in "Password confirmation" with "12345678"
      And I press "Sign up"
    Then I should see "đã có"

  Scenario: Sign up with short password (< 8 characters)
    When I go to the signup page
      And I fill in "Email" with "vumanhcuong01@gmail.com"
      And I fill in "user_password" with "12348"
      And I fill in "Password confirmation" with "12348"
      And I press "Sign up"
    Then I should see "quá ngắn (tối thiểu 8 ký tự)"

  Scenario: Create a new project successfully
    Given there is a user with the email "vumanhcuong01@gmail.com" and the id "10" and the password "12345678" and the password confirmation "12345678"
      And I am a new, authenticated user
    When I go to the new project page
      And I fill in "Title" with "Push the world"
      And I fill in "Description" with "World is bullshit"
      And I fill in "Start date" with "2013-09-10"
      And I fill in "End date" with "2013-09-24"
      And I fill in "Funding goal" with "9999999"
      And I fill in "Location" with "227 Nguyen Van Cu"
      And I press "Create Project"
    Then  I should see "Title: Push the world"
      And I should see "Description: World is bullshit"
      And I should see "Edit"

  Scenario: Create a new project unsuccessfully
    Given there is a user with the email "vumanhcuong01@gmail.com" and the id "1" and the password "12345678" and the password confirmation "12345678"
      And I am a new, authenticated user
    When I go to the new project page
      And I fill in "Title" with ""
      And I fill in "Description" with "World is bullshit"
      And I fill in "Start date" with "2013-09-10"
      And I fill in "End date" with "2013-09-24"
      And I fill in "Funding goal" with ""
      And I fill in "Location" with "227 Nguyen Van Cu"
      And I press "Create Project"
    Then  I should see "errors prohibited"
      And I should see "Title không thể để trắng"
      And I should see "Funding goal không thể để trắng"

  Scenario: Create a new project with right slug
    Given there is a project with the title "Push The World" and the slug "push-the-world" and the user id "1" and the description "test slug" and the Start date "2013-09-11" and the End date "2013-09-12" and the funding goal "234234" and the location "HCM"
      And there is a user with the email "vumanhcuong@gmail.com" and the id "1"
      And I am a new, authenticated user
      And I go to the project page with slug 01
    Then the "Title" field should contain "Push The World"

  
  Scenario: Update the project and check slug
    Given there is a project with the title "Push The World" and the slug "push-the-world" and the user id "1" and the description "test slug" and the Start date "2013-09-11" and the End date "2013-09-12" and the funding goal "234234" and the location "HCM"
      And there is a user with the email "vumanhcuong@gmail.com" and the id "1"
      And I am a new, authenticated user
      # push-the-world
      And I go to the project page with slug 01 
      And I fill in "Title" with "Kick The School"
      And I press "Create Project"
      # kick-the-school
    Then  I go to the project page with slug 02  
      And the "Title" field should contain "Kick The School"
