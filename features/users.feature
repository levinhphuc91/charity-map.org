@api-call
Feature: User

  Scenario: To be able to retrieve password
    Given there is a user with the full name "Cuong Vu" and the email "cuong@charity-map.org" and the password "12345678" and the password confirmation "12345678"
    When I am on the forgot-your-password page
      And I fill in "Email" with "cuong@charity-map.org"
      And I press "Send me reset password instructions"
    Then I should see "Bạn sẽ nhận được email hướng dẫn thiết lập lại mật khẩu trong vài phút nữa."
      And "cuong@charity-map.org" should receive an email
    When I open the email
    When I follow "Change my password" in the email
    Then I should see "Change your password"

  Scenario: To have a profile
    Given there is a user with the full name "Tu Hoang" and the email "tu@charity-map.org" and the password "12345678" and the password confirmation "12345678"
    When I go to the profile of "Tu Hoang"
    Then I should see "Tu Hoang"
      And I should see page title as "Tu Hoang"

  Scenario: Update their profile settings
    Given I am a new, authenticated user
      And I am on the users settings page
      And I should see "Vị trí không xác định được trên bản đồ. Hãy thử tìm địa chỉ của bạn trên Google Maps trước."
      And I fill in "user_email" with "saidrebyn@gmail.com"
      And I fill in "Họ và Tên*" with "Hoang Minh Tu"
      And I fill in "Địa chỉ*" with "10.5B D5 Binh Thanh"
      # And I select "Hồ Chí Minh" from "City"
      And I fill in "Giới Thiệu" with "Charity Map co-founders"
      And I fill in "Số ĐT*" with "0908 230 591"
      And I press "Cập nhật Thông Tin"
    Then I should see "Cập nhật thành công."
    When I follow "Xem Trang Của Bạn"
    Then I should see "Người dùng chưa tạo dự án trên hệ thống."

  Scenario: Visit dashboard, as a backer, without donations 
    Given I am a new, authenticated user
      And I follow "Đến Trang Quản Lý"
      And I follow "Đóng Góp"
    Then I should see "Hiện chưa có thống kê về những khoản tài trợ bạn đã đóng góp."

  Scenario: Visit dashboard, as a backer having donations 
    Given there is a user with the email "vumanhcuong01@gmail.com" and the id "1" and the password "12345678" and the password confirmation "12345678"
      And there is a project with the id "1" title "Books from Heart" and the description "Giving away libraries for suburban schools." and the start date "2014-05-23" and the end date "2014-05-30" and the funding goal "5000000" and the location "Ho Chi Minh City" and the user id "1"
      And there is a project reward with the value "100000" and the description "Test Note" with the project above
      And there is a donation with the user id "1" and the project id "1" and the amount "500000" and the collection method "COD" and the status "SUCCESSFUL" with the project reward above
    When I go to the login page
      And I fill in "user_email" with "vumanhcuong01@gmail.com"
      And I fill in "user_password" with "12345678"
      And I press "Đăng Nhập"
      And I follow "Đến Trang Quản Lý"
      And I follow "Đóng Góp"
    Then I should see "500.000"

  Scenario: Visit dashboard, as a project creator
    Given there is a user with the email "vumanhcuong01@gmail.com" and the id "1" and the password "12345678" and the password confirmation "12345678"
      And there is a project with the id "1" and the title "Books from Heart" and the description "Giving away libraries for suburban schools." and the start date "2014-05-23" and the end date "2014-05-30" and the funding goal "5000000" and the location "Ho Chi Minh City" with the user above
      And there is a project reward with the value "100000" and the description "Test Note" with the project above
      And there is a donation with the user id "2" and the amount "250000" and the status "SUCCESSFUL" and the collection method "COD" with the project above and the project reward above
      And there is a donation with the user id "3" and the amount "250000" and the collection method "COD" and the status "SUCCESSFUL" with the project above and the project reward above
    When I go to the login page
      And I fill in "user_email" with "vumanhcuong01@gmail.com"
      And I fill in "user_password" with "12345678"
      And I press "Đăng Nhập"
      And I follow "Đến Trang Quản Lý"
    Then I should see "Books from Heart"
      And I should see "500.000 VNĐ được ủng hộ"
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

  Scenario: Sign up with short password (< 6 characters)
    When I go to the signup page
      And I fill in "user_email" with "vumanhcuong01@gmail.com"
      And I fill in "user_password" with "12345"
      And I fill in "user_password_confirmation" with "12345"
      And I press "Đăng Ký"
    Then I should see "quá ngắn (tối thiểu 6 ký tự)"

  Scenario: Get a new password successfully
    Given there is a user with the email "vumanhcuong@gmail.com" and the id "1" and the password "12345678" and the password confirmation "12345678"
    When I go to the forgot password page
      And I fill in "user_email" with "vumanhcuong@gmail.com"
      And I press "Send me reset password instructions"
    Then I should see "Bạn sẽ nhận được email hướng dẫn thiết lập lại mật khẩu trong vài phút nữa."

  Scenario: Change password successfully
    Given there is a user with the email "vumanhcuong@gmail.com" and the password "secretpass" and the password confirmation "secretpass"
    When I login as "vumanhcuong@gmail.com"
      And I go to the users settings page
      And I fill in "Mật khẩu mới" with "123456789"
      And I fill in "Điền lại mật khẩu mới" with "123456789"
      And I fill in "Mật khẩu cũ để thay đổi mật khẩu" with "secretpass"
      And I press "Thay đổi mật khẩu"
    Then I should see "Cập nhật tài khoản thành công."
    Given I am not authenticated
    When I go to the login page
      And I fill in "user_email" with "vumanhcuong@gmail.com"
      And I fill in "user_password" with "123456789"
      And I press "Đăng Nhập"
    Then I should see "Đăng nhập thành công."
    And I go to the users settings page
      And I fill in "Mật khẩu mới" with "secretpass"
      And I fill in "Điền lại mật khẩu mới" with "secretpass"
      And I fill in "Mật khẩu cũ để thay đổi mật khẩu" with "1234567000"
      And I press "Thay đổi mật khẩu"
    Then I should see "không hợp lệ"
      And I fill in "Mật khẩu mới" with "secretpass"
      And I fill in "Điền lại mật khẩu mới" with "secretpass"
      And I fill in "Mật khẩu cũ để thay đổi mật khẩu" with "123456789"
      And I press "Thay đổi mật khẩu"
    Then I should see "Cập nhật tài khoản thành công."

  Scenario: Get a new password with non-existing email
    Given there is a user with the email "vumanhcuong@gmail.com" and the id "1" and the password "12345678" and the password confirmation "12345678"
    When I go to the forgot password page
      And I fill in "user_email" with "cuong@gmail.com"
      And I press "Send me reset password instructions"
    Then  I should see "Please review the problems below:"
      And I should see "không tìm thấy"

  Scenario: To be able to login using Facebook
    When I login via Facebook
    Then I should see "Đăng nhập thành công bằng tài khoản Facebook."
    When I go to the users settings page
    Then the "Email" field should contain "user@man.net"

  Scenario: Won't be tracked by Google Analytics for logging in via FB
    Given the date is "2013-09-10"
      And I login via Facebook
      Then I should see "Đăng nhập thành công bằng tài khoản Facebook."
    When I disable outgoing GA call
      And I am not authenticated
      And the date is "2013-09-13"
      And I login via Facebook
    Then I should see "Đăng nhập thành công bằng tài khoản Facebook."

  Scenario: To be able to login using Facebook / having an existing account
    Given there is a user with the email "user@man.net" and the password "secretpass" and the password confirmation "secretpass"
    When I login via Facebook
    Then I should see "Đăng nhập thành công bằng tài khoản Facebook."
    When I go to the users settings page
    Then the "Email" field should contain "user@man.net"

  Scenario: To be able to connect his Facebook account / having an existing account
    Given there is a user with the email "user@man.net" and the password "secretpass" and the password confirmation "secretpass"
    When I login as "user@man.net"
      And I go to the users settings page
      Then I should see "Kết nối TK Facebook"
    When I connect my Facebook account
    Then I should see "Đăng nhập thành công bằng tài khoản Facebook."
    When I go to the users settings page
    Then the "Email" field should contain "user@man.net"

  Scenario: To be sent verification code via phone
    Given there is a user with the email "vumanhcuong@gmail.com" and the password "secretpass" and the password confirmation "secretpass"
    When I login as "vumanhcuong@gmail.com"
      And I go to the users settings page
      And I follow "Xác Nhận Tài Khoản"
    Then I should not see "Tài khoản đã được xác nhận."
      And I fill in "phone_number" with "0908230591"
      And I press "Gửi Mã"
    Then I should see "Mã xác nhận vừa được gửi tới số +84908230591. Mời bạn điền mã vào ô dưới để hoàn tất quá trình xác nhận."
      And I should see "Điền vào ô bên dưới đoạn mã 6 chữ số đã được gửi đến số 0908230591 của bạn:"

  Scenario: To submit verification code
    Given there is a user with the email "vumanhcuong@gmail.com" and the password "secretpass" and the password confirmation "secretpass"
      And there is a verification with the code "123456" and the user above
    When I login as "vumanhcuong@gmail.com"
      And I go to the users settings page
      And I follow "Xác Nhận Tài Khoản"
    Then I should not see "Tài khoản đã được xác nhận."
      And I fill in "phone_code" with "123456"
      And I press "Xác Nhận"
    Then I should see "Xác nhận danh tính bằng số điện thoại hoàn tất."
      And I should see "Tài khoản đã được xác nhận."

  # TODO: FIX
  # Scenario: User message each other
  #   Given there is a user with the email "vumanhcuong01@gmail.com" and the password "secretpass" and the password confirmation "secretpass" and the full name "Vu Manh Cuong" and the address "HCM" and the city "HCM" and the phone "123456"
  #   And there is a user with the full name "Testing Man" and the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass"
  #   When I login as "vumanhcuong01@gmail.com"
  #     And I go to the profile of "Testing Man"
  #     And I follow "Gửi Tin Nhắn"
  #   Then I fill in "acts_as_messageable_message_body" with "First Message"
  #     And I press "Gửi tin nhắn"
  #   Then I should see "Tin nhắn đã được gửi đi."
  #     And I am not authenticated
  #     And I login as "testing@man.net"
  #   When I go to the message page
  #     And I should see "First Message"
  #     And I follow "Trả lời"
  #   Then I fill in "acts_as_messageable_message_body" with "Reply"
  #     And I press "Trả lời tin nhắn"
  #   Then I should see "Tin nhắn đã được gửi đi."

  Scenario: Permission denied for viewing dashboard of projects that don't belong to him/her
    Given the date is "2014-09-01"
      And there is a user with the email "vumanhcuong01@gmail.com" and the password "secretpass" and the password confirmation "secretpass" and the full name "Vu Manh Cuong" and the address "HCM" and the city "HCM" and the phone "123456"
      And there is a user with the full name "Testing Man" and the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass"
      And there is a project with the title "Books from Heart" and the brief "This is a short brief" and the description "Giving away libraries for suburban schools." and the start date "2014-09-02" and the end date "2014-09-30" and the funding goal "5000000" and the location "Ho Chi Minh City" and the status "FINISHED" with the user above
    When I login as "vumanhcuong01@gmail.com"
      And I go to the dashboard of the project "Books from Heart"
    Then I should see "Ủng hộ từ thiện chưa bao giờ dễ dàng đến vậy."
      And the URL should not contain "/dashboard"

  # TODO: add test for Xoa du an truoc day
  Scenario: To be able to have a portfolio profile
    Given the date is "2014-09-01"
      And there is a user with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass"
    When I login as "testing@man.net"
      And I go to the users settings page
    Then the "user_org" checkbox should not be checked
    When I check "user_org"
      And I press "Cập nhật Thông Tin"
    Then the "user_org" checkbox should be checked
    When I follow "Xem Trang Của Bạn"
    Then I should see "Dự Án Trước Đây"

  Scenario: Receive update on fundraising projects 2 days from signup
    Given the date is "2013-09-10"
      And I create an item based project named "Push The World"
      And I start fundraising for project "Push The World"
      And I list out a project named "Push The World"
    Given the date is "2013-09-11"
      And I am not authenticated
      When I go to the signup page
      And I fill in "user_email" with "vumanhcuong0103@gmail.com"
      And I fill in "user_password" with "12345678"
      And I fill in "user_password_confirmation" with "12345678"
      And I press "Đăng Ký"
    Then I should see "Xin chào! Bạn đã đăng ký thành công."
    Then an email should have been sent with:
      """
      From: team@charity-map.org
      To: vumanhcuong0103@gmail.com
      Subject: 1 dự án đang rất cần sự hỗ trợ của bạn
      """
    And "vumanhcuong0103@gmail.com" should receive an email
    When I open the email
    Then I should see "Push The World" in the email body
    When I follow "Push The World" in the email
    Then I should see "Push The World"
    And the URL should contain "projects/push-the-world"

  # Scenario: Not to receive updates via email and Facebook
  #   Given the date is 2013-09-11
  #     And there is a user with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass"
  #     And there is a project with the title "Push The World" and the description "test slug" and the start date "2013-09-11" and the end date "2013-09-13" and the funding goal "234234" and the location "HCM" and the status "REVIEWED" with the user above
  #     And there is a project reward with the value "12340" the description "reward description" with the project above
  #     And there is a user with the email "donor@man.net" and the password "secretpass" and the password confirmation "secretpass" and the full name "Nguoi Ung Ho" and the address "HCM" and the city "HCM" and the phone "123456" and the notify via facebook "false" and the notify via email "false"
  #   Given the date is "2013-09-12"
  #   When I login as "donor@man.net"
  #     And I go to the project page of "Push The World"
  #     And I follow "ủng hộ dự án"
  #     And I fill in "donation_amount" with "12345"
  #     And I fill in "donation_note" with "Nothing"
  #     And I select "Chuyển khoản ngân hàng" from "donation_collection_method"
  #     And I press "Ủng Hộ Push The World"
  #   Then "donor@man.net" should receive an email
  #   When I open the email
  #     And I follow "đường dẫn này" in the email
  #   When I am not authenticated
  #     And I login as "testing@man.net"
  #     And "testing@man.net" should receive an email
  #     And I open the email
  #     And I follow "đường dẫn này" in the email
  #     And I follow "Xác nhận ủng hộ"
  #   Then I should see "Xác nhận thành công. Email vừa được gửi tới mạnh thường quân thông báo bạn đã nhận được tiền."
  #     And no email should have been sent with:
  #       """
  #       From: team@charity-map.org
  #       To: donor@man.net
  #       Subject: Xác nhận giao dịch CKNH thành công, dự án Push The World
  #       """