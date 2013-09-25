Feature: User

  Scenario: To have a profile
    Given there is a user with the id "1" and the email "tu@charity-map.org" and the password "12345678" and the password confirmation "12345678"
    When I go to the profile of user "1"
    Then the URL should contain "/user/1"

  Scenario: Update their profile settings
    Given I am a new, authenticated user
      And I am on the users settings page
      And I fill in "user_email" with "saidrebyn@gmail.com"
      And I fill in "Full name" with "Hoang Minh Tu"
      And I fill in "Address" with "10.5B D5 Binh Thanh"
      And I select "Hồ Chí Minh" from "City"
      And I fill in "Bio" with "Charity Map co-founders"
      And I fill in "Phone" with "0908 230 591"
      And I press "Cập nhật Thông Tin"
    Then I should see "Cập nhật thành công."

  Scenario: Visit dashboard, as a backer, without donations 
    Given I am a new, authenticated user
    When I go to the dashboard
      And I follow "Đóng Góp"
    Then I should see "Hiện chưa có thống kê về những khoản tài trợ bạn đã đóng góp."

  Scenario: Visit dashboard, as a backer having donations 
    Given there is a user with the email "vumanhcuong01@gmail.com" and the id "1" and the password "12345678" and the password confirmation "12345678"
      And there is a project with the id "1" title "Books from Heart" and the description "Giving away libraries for suburban schools." and the start date "2014-05-23" and the end date "2014-05-30" and the funding goal "5000000" and the location "Ho Chi Minh City" and the user id "1"
      And there is a project reward with the amount "100000" and the description "Test Note" with the project above
      And there is a donation with the user id "1" and the project id "1" and the amount "500000" and the collection method "COD" and the status "SUCCESSFUL" with the project reward above
    When I go to the login page
      And I fill in "user_email" with "vumanhcuong01@gmail.com"
      And I fill in "user_password" with "12345678"
      And I press "Đăng Nhập"
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
      And I fill in "user_email" with "vumanhcuong01@gmail.com"
      And I fill in "user_password" with "12345678"
      And I press "Đăng Nhập"
    When I go to the dashboard
    Then I should see "Books from Heart"
      And I should see "500.000 đ được ủng hộ"
      And I should see "0% hoàn thành"
      And I should see "2 mạnh thường quân"
      And I should see "0 giới thiệu"

  Scenario: Sign in Charity Map successfully
    Given there is a user with the email "vumanhcuong01@gmail.com" and the id "1" and the password "12345678" and the password confirmation "12345678"
    When I go to the login page
      And I fill in "user_email" with "vumanhcuong01@gmail.com"
      And I fill in "user_password" with "12345678"
      And I press "Đăng Nhập" 
    Then I should see "Đăng nhập thành công."

  Scenario: Sign in Charity Map with invalid email & password
    Given there is a user with the email "vumanhcuong01@gmail.com" and the id "1" and the password "12345678" and the password confirmation "12345678"
    When I go to the login page
      And I fill in "user_email" with "vumanhcuon@gmail.com"
      And I fill in "user_password" with "12345"
      And I press "Đăng Nhập" 
    Then I should see "Email hoặc mật khẩu không chính xác."

  Scenario: Sign up successfully
    When I go to the signup page
      And I fill in "user_email" with "vumanhcuong0103@gmail.com"
      And I fill in "user_password" with "12345678"
      And I fill in "user_password_confirmation" with "12345678"
      And I press "Đăng Ký"
    Then I should see "Xin chào! Bạn đã đăng ký thành công."
  
  Scenario: Sign up with existing email 
    Given there is a user with the email "vumanhcuong01@gmail.com" and the id "1" and the password "12345678" and the password confirmation "12345678"
    When I go to the signup page
      And I fill in "user_email" with "vumanhcuong01@gmail.com"
      And I fill in "user_password" with "12345678"
      And I fill in "user_password_confirmation" with "12345678"
      And I press "Đăng Ký"
    Then I should see "đã có"

  Scenario: Sign up with short password (< 8 characters)
    When I go to the signup page
      And I fill in "user_email" with "vumanhcuong01@gmail.com"
      And I fill in "user_password" with "12348"
      And I fill in "user_password_confirmation" with "12348"
      And I press "Đăng Ký"
    Then I should see "quá ngắn (tối thiểu 8 ký tự)"

  Scenario: Get a new password successfully
    Given there is a user with the email "vumanhcuong@gmail.com" and the id "1" and the password "12345678" and the password confirmation "12345678"
    When I go to the forgot password page
      And I fill in "user_email" with "vumanhcuong@gmail.com"
      And I press "Send me reset password instructions"
    Then I should see "Bạn sẽ nhận được email hướng dẫn thiết lập lại mật khẩu trong vài phút nữa."

  Scenario: Get a new password with non-existing email
    Given there is a user with the email "vumanhcuong@gmail.com" and the id "1" and the password "12345678" and the password confirmation "12345678"
    When I go to the forgot password page
      And I fill in "user_email" with "cuong@gmail.com"
      And I press "Send me reset password instructions"
    Then  I should see "Some errors were found, please take a look"
      And I should see "không tìm thấy"

  Scenario: To be able to login using Facebook
    When I login via Facebook
    Then I should see "Đăng nhập thành công bằng tài khoản Facebook."
    When I go to the users settings page
    Then the "Email" field should contain "user@man.net"

  Scenario: To be sent verification code via phone
    Given there is a user with the email "vumanhcuong@gmail.com" and the password "secretpass" and the password confirmation "secretpass"
    When I login as "vumanhcuong@gmail.com"
      And I go to the users settings page
      And I follow "Xác Nhận Tài Khoản"
      And I fill in "phone_number" with "0908230591"
      And I press "Gửi Mã"
    Then I should see "Mã xác nhận vừa được gửi tới số +84908230591. Mời bạn điền mã vào ô dưới để hoàn tất quá trình xác nhận."

  Scenario: To submit verification code
    Given there is a user with the email "vumanhcuong@gmail.com" and the password "secretpass" and the password confirmation "secretpass"
      And there is a verification with the code "123456" and the user above
    When I login as "vumanhcuong@gmail.com"
      And I go to the users settings page
      And I follow "Xác Nhận Tài Khoản"
      And I fill in "phone_code" with "123456"
      And I press "Xác Nhận"
    Then I should see "Xác nhận danh tính bằng số điện thoại hoàn tất."

  Scenario: User message each other
    Given there is a user with the email "vumanhcuong01@gmail.com" and the password "secretpass" and the password confirmation "secretpass" and the full name "Vu Manh Cuong" and the address "HCM" and the city "HCM" and the phone "123456" and the id "1"
    And there is a user with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass" and the id "2"
    When I login as "vumanhcuong01@gmail.com"
      And I go to the profile of user "2"
      And I follow "Gửi tin nhắn"      
    Then I fill in "acts_as_messageable_message_body" with "First Message"
      And I press "Gửi tin nhắn"
    Then I should see "Tin nhắn đã được gửi đi."
      And I am not authenticated
      And I login as "testing@man.net"
    When I go to the message page
      And I should see "First Message"
      And I follow "Trả lời"
    Then I fill in "acts_as_messageable_message_body" with "Reply"
      And I press "Trả lời tin nhắn"
    Then I should see "Tin nhắn đã được gửi đi."