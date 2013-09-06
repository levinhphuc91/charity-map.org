Feature: User

  Scenario: To have a profile
    Given there is a user with the id "1" and the email "tu@charity-map.org" and the password "12345678" and the password confirmation "12345678"
    When I go to the profile of user "1"
    Then the URL should contain "/user/1"

  Scenario: Update their profile settings
    Given I am a new, authenticated user
      And I am on the users settings page
      And I fill in "Email" with "saidrebyn@gmail.com"
      And I fill in "Full name" with "Hoang Minh Tu"
      And I fill in "Address" with "10.5B D5 Binh Thanh"
      And I select "Hồ Chí Minh" from "City"
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
      And there is a project with the id "1" title "Books from Heart" and the description "Giving away libraries for suburban schools." and the start date "2014-05-23" and the end date "2014-05-30" and the funding goal "5000000" and the location "Ho Chi Minh City" and the user id "1"
      And there is a project reward with the amount "100000" and the description "Test Note" with the project above
      And there is a donation with the user id "1" and the project id "1" and the amount "500000" and the collection method "COD" with the project reward above
    When I go to the login page
      And I fill in "Email" with "vumanhcuong01@gmail.com"
      And I fill in "Password" with "12345678"
      And I press "Sign in"
    When I go to the dashboard
    Then I should see "500.000"
      And I should see "Thu Tiền Mặt"

  Scenario: Visit dashboard, as a project creator
    Given there is a user with the email "vumanhcuong01@gmail.com" and the id "1" and the password "12345678" and the password confirmation "12345678"
      And there is a project with the id "1" and the title "Books from Heart" and the description "Giving away libraries for suburban schools." and the start date "2014-05-23" and the end date "2014-05-30" and the funding goal "5000000" and the location "Ho Chi Minh City" with the user above
      And there is a project reward with the amount "100000" and the description "Test Note" with the project above
      And there is a donation with the user id "2" and the amount "250000" and the status "SUCCESSFUL" and the collection method "COD" with the project above and the project reward above
      And there is a donation with the user id "3" and the amount "250000" and the collection method "COD" and the status "SUCCESSFUL" with the project above and the project reward above
    When I go to the login page
      And I fill in "Email" with "vumanhcuong01@gmail.com"
      And I fill in "Password" with "12345678"
      And I press "Sign in"
    When I go to the dashboard
    Then I should see "Books from Heart"
      And I should see "5.000.000 đ"
      And I should see "500.000 đ"
      And I should see "2 MTQ"

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

  Scenario: Get a new password successfully
    Given there is a user with the email "vumanhcuong@gmail.com" and the id "1" and the password "12345678" and the password confirmation "12345678"
    When I go to the forgot password page
      And I fill in "Email" with "vumanhcuong@gmail.com"
      And I press "Send me reset password instructions"
    Then I should see "Bạn sẽ nhận được email hướng dẫn thiết lập lại mật khẩu trong vài phút nữa."

  Scenario: Get a new password with non-existing email
    Given there is a user with the email "vumanhcuong@gmail.com" and the id "1" and the password "12345678" and the password confirmation "12345678"
    When I go to the forgot password page
      And I fill in "Email" with "cuong@gmail.com"
      And I press "Send me reset password instructions"
    Then  I should see "Some errors were found, please take a look"
      And I should see "không tìm thấy"
