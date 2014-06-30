@api-call
Feature: Project
  Scenario: To be displayed in a box
    Given there is a user with the full name "Hoang Minh Tu" and the password "12345678" and the password confirmation "12345678"
      And there is a project with the title "Books from Heart" and the brief "This is a short brief" and the description "Giving away libraries for suburban schools." and the start date "2014-09-02" and the end date "2014-09-30" and the funding goal "5000000" and the location "Ho Chi Minh City" and the status "FINISHED" with the user above that is not unlisted
    When I go to the project listing page
    Then I should see "Books from Heart"
      And I should see "This is a short brief"

  Scenario: To be unable to create a project without full_name or address
    Given there is a user with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass"
    When I go to the login page
      And I fill in "user_email" with "testing@man.net"
      And I fill in "user_password" with "secretpass"
      And I press "Đăng Nhập"
    When I go to the new project page
      Then I should see "Phiền bạn cập nhật đầy đủ tên họ và địa chỉ trước khi tạo dự án."

  @javascript
  Scenario: To be created successfully
    Given the date is 2013-09-10
      And there is a user with the email "vumanhcuong01@gmail.com" and the password "secretpass" and the password confirmation "secretpass" and the full name "Vu Manh Cuong" and the address "HCM" and the city "HCM" and the phone "123456"
    When I login as "vumanhcuong01@gmail.com"
      And I go to the new project page
      And I fill in "project_title" with "Push the world"
      And I fill in "project_brief" with "This is a short brief"
      And I fill in "project_description" with "Here comes a description"
      And I fill in "project_start_date" with "10/09/2013"
      And I fill in "project_end_date" with "24/09/2013"
      And I fill in "project_funding_goal" with "9999999"
      And I fill in "project_location" with "227 Nguyen Van Cu"
      And I press "Lưu"
    Then  I should see "Push the world"
      And I should see page title as "Push the world"
      And I should see "Here comes a description"
      And I should see "Quản Lý Dự Án"
    When I follow "Cập Nhật"
    Then I should see "Hiện dự án Push the world chưa có cập nhật nào."

  Scenario: To be given a slug
    Given the date is 2013-09-11
      And there is a user with the email "creator@man.net" and the password "secretpass" and the password confirmation "secretpass" and the full name "Tu Hoang"
      And there is a project with the title "Push The World" and the description "test slug" and the start date "2013-09-11" and the end date "2013-09-12" and the funding goal "234234" and the location "HCM" and the status "REVIEWED" with the user above
      And I am a new, authenticated user
    When I go to the project page of "Push The World"
    Then the URL should contain "push-the-world"

  Scenario: To be given an updated slug after edit
    Given the date is 2013-09-11
      And there is a user with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass"
      And there is a project with the title "Push The World" and the description "test slug" and the start date "2013-09-11" and the end date "2013-09-12" and the funding goal "234234" and the location "HCM" with the user above
    When I go to the login page
      And I fill in "user_email" with "testing@man.net"
      And I fill in "user_password" with "secretpass"
      And I press "Đăng Nhập"
      And I go to the project page of "Push The World"
      And I follow "Quản Lý"
      And I follow "Push The World"
      And I follow "Chỉnh Sửa"
      And I fill in "project_title" with "Kick The School"
      And I press "Lưu" within ".project"
      And I go to the project page of "Kick The School"
      Then the URL should contain "kick-the-school"

  Scenario: To be submitted for review
    Given the date is 2013-09-11
      And there is a user with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass"
      And there is a project with the title "Push The World" and the description "test project update" and the start date "2013-09-22" and the end date "2013-09-30" and the funding goal "234234" and the location "HCM" with the user above 
    When I login as "testing@man.net"
      And I go to the project page of "Push The World"
      And I follow "Tiến Hành Gây Quỹ"
    Then I should see "Phải có ít nhất một Đề mục đóng góp (project reward)."
      And I fill in "project_reward_value" with "100000"
      And I fill in "project_reward_description" with "Test Description"
      And I press "Lưu"
    When I go to the project page of "Push The World"
      And I follow "Tiến Hành Gây Quỹ"
    Then I should see "Dự án chuyển sang trạng thái gây quỹ."
    Then an email should have been sent with:
      """
      From: tu@charity-map.org
      To: team@charity-map.org
      Subject: A project has just been submitted for review
      """
    And "team@charity-map.org" should receive an email
    When I open the email
    Then I should see "A user has just start raising fund for his/her project." in the email body
      And I should see "[Link to Project Page]" in the email body
    When I follow "[Link to Project Page]" in the email
    Then I should see "Push The World"

  Scenario: Edit project without permission
    Given the time is 2013-09-11
    Given I am a new, authenticated user
      And there is a user with the email "vumanhcuong01@gmail.com" and the id "1" and the password "12345678" and the password confirmation "12345678"
      And there is a project with the title "Push The World" and the user id "1" and the description "test slug" and the start date "2013-09-11" and the end date "2013-09-12" and the funding goal "234234" and the location "HCM"
    When I go to the edit page of the project "Push The World"
    Then I should see "Permission denied."

  Scenario: Add project update
    Given the date is 2013-09-11
      And there is a user with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass"
      And there is a project with the title "Push The World" and the description "test project update" and the start date "2013-09-22" and the end date "2013-09-30" and the funding goal "234234" and the location "HCM" and the status "REVIEWED" with the user above 
    When I login as "testing@man.net"
      And I go to the edit page of the project "Push The World"
      And I follow "Về lại Trang Quản Lý"
      And I follow "Cập Nhật"
      And I fill in "Tên cập nhật" with "Test Update Title"
      And I fill in "Nội dung cập nhật" with "Test Update Content"
      And I press "Cập Nhật"
    Then I should see "Vừa thêm Cập nhật dự án mới."
    Then I should see "Test Update Title"
    Then I should see "Cập nhật 1"
    When I go to the project page of "Push The World"
      And I follow "Cập Nhật"
    Then I should see "Click để xem thêm thông tin."
      And I follow "Test Update Title"
    Then the URL should contain "projects/push-the-world/project_updates"
    When I get redirected via the last redirect token
    Then I should see "Test Update Content"
    And the URL should contain "?utm_campaign=NotifOnPUpdate"

  Scenario: Add updates unsuccessfully (status != FINISHED != REVIEWED)
    Given the date is 2013-09-11
      And there is a user with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass"
      And there is a project with the title "Push The World" and the description "test project update" and the start date "2013-09-22" and the end date "2013-09-30" and the funding goal "234234" and the location "HCM" and the status "DRAFT" with the user above 
    When I login as "testing@man.net"
      And I go to the edit page of the project "Push The World"
      And I follow "Về lại Trang Quản Lý"
      And I follow "Cập Nhật"
    Then I should see "Permission denied."

  Scenario: Add new reward on dashboard/project page
    Given the date is 2013-09-11
      And there is a user with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass"
      And there is a project with the title "Push The World" and the description "test project update" and the start date "2013-09-22" and the end date "2013-09-30" and the funding goal "234234" and the location "HCM" and the status "REVIEWED" with the user above
    When I login as "testing@man.net"
      And I go to the edit page of the project "Push The World"
      And I follow "Về lại Trang Quản Lý"
      And I follow "Đề Mục Đóng Góp"
    Then I should see "Hiện chưa có đề mục đóng góp nào được ghi nhận."
      And I fill in "project_reward_value" with "99999"
      And I fill in "project_reward_description" with "Bla Bla"
      And I press "Lưu" within "#new_project_reward"
    Then I should see "Vừa thêm Đề mục đóng góp mới."
    #   And I fill in "project_reward_value" with "99999"
    #   And I fill in "project_reward_description" with "A duplicate reward"
    #   And I press "Lưu" within "#new_project_reward"
    # Then I should see "Lỗi: Value đã có"
      And I follow "Sửa"
      And I follow "Xóa"
    Then I should see "Xóa đề mục đóng góp thành công."

  # Scenario: To be given recommendations only in "REVIEWED" or "FINISHED" state
  #   Given the date is 2013-09-11
  #     And there is a user with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass" and the verified_by_phone "true"
  #   And there is a project with the title "Push The World" and the description "test project update" and the start date "2013-09-22" and the end date "2013-09-30" and the funding goal "234234" and the location "HCM" and the status "REVIEWED" with the user above
  #   When I login as "testing@man.net"
  #     And I go to the project page of "Push The World"
  #     And I follow "Viết Lời Giới Thiệu"
  #   Then I should see "Permission denied"
  #     And there is a user with the email "reviewer@man.net" and the password "secretpass" and the password confirmation "secretpass" and the verified_by_phone "true"
  #     And I am not authenticated
  #     And I login as "reviewer@man.net"
  #     And I go to the project page of "Push The World"
  #     And I follow "Viết Lời Giới Thiệu"
  #     And I fill in "Content" with "This is such a good project"
  #     And I press "Create Recommendation"
  #   Then I should see "Lời giới thiệu đã được lưu."
  #     And I should see "This is such a good project"
  #     And I should see "[Edit]" within ".edit_recommendation"

  Scenario: Add new comment on project page
    Given the date is 2013-09-11
      And there is a user with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass"
      And there is a project with the title "Push The World" and the description "test project update" and the start date "2013-09-22" and the end date "2013-09-30" and the funding goal "234234" and the location "HCM" and the status "REVIEWED" with the user above
    When I login as "testing@man.net"
      And I go to the project page of "Push The World"
      And I follow "Bình Luận"
      And I fill in "project_comment_content" with "It's a new comment"
      And I press "gửi bình luận"
    Then I should see "Bình luận vừa được thêm."
      And I should see "It's a new comment"

  Scenario: Allows only Youtube or Vimeo video link
    Given the date is 2013-09-11
      And there is a user with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass"
      And there is a project with the title "Push The World" and the description "test project update" and the start date "2013-09-22" and the end date "2013-09-30" and the funding goal "234234" and the location "HCM" and the status "REVIEWED" with the user above
    When I login as "testing@man.net"
      And I go to the edit page of the project "Push The World"
      And I fill in "project_video" with "www.google.com"
      And I press "Lưu" within ".project"
    Then I should see "only valid Vimeo or YouTube URLs are allowed"
      And I fill in "project_video" with "www.youtube.com"
      And I press "Lưu" within ".project"
    Then I should see "only valid Vimeo or YouTube URLs are allowed"
      And I fill in "project_video" with "http://www.youtube.com/watch?v=cikKIIqL78g"
      And I press "Lưu" within ".project"
    Then I should not see "only valid Vimeo or YouTube URLs are allowed"
      And I go to the edit page of the project "Push The World"
      And I fill in "project_video" with "www.vimeo.com"
      And I press "Lưu" within ".project"
    Then I should see "only valid Vimeo or YouTube URLs are allowed"
      And I fill in "project_video" with "https://vimeo.com/63387028"
      And I press "Lưu" within ".project"
    Then I should not see "only valid Vimeo or YouTube URLs are allowed"

  @javascript
  Scenario: AJAX Follow a project
    Given the date is 2013-09-11
      And there is a user with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass"
      And there is a project with the title "Push The World" and the description "test project update" and the start date "2013-09-22" and the end date "2013-09-30" and the funding goal "234234" and the location "HCM" and the status "REVIEWED" with the user above
      And there is a user with the email "follower@man.net" and the password "secretpass" and the password confirmation "secretpass" and the full name "Nguoi Ung Ho" and the address "HCM" and the city "HCM" and the phone "123456"
    When I login as "follower@man.net"
      And I go to the project page of "Push The World"
      And I follow "nhận cập nhật"
    Then I should see "đang nhận cập nhật"

  Scenario: Send project update to followers via email
    Given the date is 2013-09-11
      And there is a user with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass"
      And there is a project with the title "Push The World" and the description "test project update" and the start date "2013-09-22" and the end date "2013-09-30" and the funding goal "234234" and the location "HCM" and the status "REVIEWED" with the user above
      And there is a user with the email "follower@man.net" and the password "secretpass" and the password confirmation "secretpass" and the full name "Nguoi Ung Ho" and the address "HCM" and the city "HCM" and the phone "123456"
    When I login as "follower@man.net"
      And I go to the project page of "Push The World"
      And I follow "nhận cập nhật"
    Then I should see "Đăng ký nhận cập nhật từ dự án thành công."
    When I am not authenticated
      And I login as "testing@man.net"
      And I go to the edit page of the project "Push The World"
      And I follow "Về lại Trang Quản Lý"
      And I follow "Cập Nhật"
      And I fill in "Tên cập nhật" with "Test Update Title"
      And I fill in "Nội dung cập nhật" with "Test Update Content"
      And I press "Cập Nhật"
    Then an email should have been sent with:
      """
      From: team@charity-map.org
      To: follower@man.net
      Subject: Cập nhật mới từ dự án Push The World
      """

  Scenario: To be searched
    Given the date is 2013-09-11
      And there is a user with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass"
      And there is a project with the title "Push The World" and the description "test project update" and the start date "2013-09-22" and the end date "2013-09-30" and the funding goal "234234" and the location "HCM" and the status "REVIEWED" with the user above 
    When I go to the project listing page
      And I fill in "project_search" with "Push The World"
      And I press "Tìm"
    Then the URL should contain "push-the-world"

  Scenario: To be unlisted upon create
    Given the date is 2013-09-11
      And there is a user with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass"
      And there is a project with the title "Push The World" and the description "test project update" and the start date "2013-09-22" and the end date "2013-09-30" and the funding goal "234234" and the location "HCM" and the status "REVIEWED" with the user above 
    When I go to the project listing page
    Then I should not see "Push The World"

  @javascript
  Scenario: Add invites to project
    Given the date is 2013-09-11
      And there is a user with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass"
      And there is a project with the title "Push The World" and the description "test project update" and the start date "2013-09-22" and the end date "2013-09-30" and the funding goal "234234" and the location "HCM" and the status "REVIEWED" with the user above 
    When I login as "testing@man.net"
      And I go to the dashboard of the project "Push The World"
      And I follow "Thư Mời"
      And I press "Thêm Liên Lạc"
    Then I should see "Name không thể để trắng"
    When I fill in "Tên" with "Test Invite"
      And I fill in "Email" with "invited@gmail.com"
      And I press "Thêm Liên Lạc"
    Then I should not see "Name không thể để trắng"
      And I should see "Test Invite"
      And I should see "Sửa"
      And I should see "Gửi Thư Mời"
    When I fill in "project_invite_sms_content" with "Test Content SMS"
      And I fill in "project_invite_email_content" with "Test Email Content"
      And I press "Lưu"
    Then I should see "Cập nhật dự án thành công."
    When I follow "Gửi Thư Mời"
    # Then I should see "Thư mời đã được gửi đi."
    Then an email should have been sent with:
      """
      From: team@charity-map.org
      To: invited@gmail.com
      Subject: Đang gây quỹ: Dự án Push The World
      """
    And "invited@gmail.com" should receive an email
    When I open the email
    Then I should see "Push The World" in the email body
      And I should see "Test Email Content" in the email body
      And I should see "Thông Tin Về Dự Án" in the email body
      And I should see "Tiến Độ Gây Quỹ" in the email body
      And I should see "Về:" in the email body
    When I follow "Thông Tin Về Dự Án" in the email
    Then I should see "Push The World"
  
  Scenario: Add ext donations
    Given the date is 2013-09-11
      And there is a user with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass"
      And there is a project with the title "Push The World" and the description "test project update" and the start date "2013-09-22" and the end date "2013-09-30" and the funding goal "234234" and the location "HCM" and the status "REVIEWED" with the user above 
    When I login as "testing@man.net"
      And I go to the dashboard of the project "Push The World"
      And I follow "Thống Kê Đóng Góp"
      Then I should see "Thêm Ủng Hộ Ngoài Hệ Thống"
    When I fill in "ext_donation_donor" with "Tu Hoang"
      And I fill in "ext_donation_amount" with "100000"
      And I fill in "ext_donation_collection_time" with "12/12/2013"
      And I check "ext_donation_anon"
      And I press "Thêm"
    Then I should see "Thêm ủng hộ ngoài hệ thống thành công."
      And I should see "Ẩn Danh"

  Scenario: Import contacts from donations to invites
    Given the date is 2013-09-11
      And there is a user with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass"
      And there is a project with the title "Push The World" and the description "test project update" and the start date "2013-09-22" and the end date "2013-09-30" and the funding goal "234234" and the location "HCM" and the status "REVIEWED" with the user above 
      And there is a project with the title "After Pushing The World" and the description "test project update" and the start date "2013-09-22" and the end date "2013-09-30" and the funding goal "234234" and the location "HCM" and the status "REVIEWED" with the user above 
      And there is a project reward with the value "15000" and the description "Bla Bla Bla" with the project above
    When I login as "testing@man.net"
      And I go to the dashboard of the project "Push The World"
      And I follow "Thống Kê Đóng Góp"
    When I fill in "ext_donation_donor" with "Tu Hoang"
      And I fill in "ext_donation_amount" with "100000"
      And I fill in "ext_donation_collection_time" with "25/09/2013"
      And I fill in "ext_donation_email" with "donor@mail.net"
      And I press "Thêm"
    When I go to the dashboard of the project "After Pushing The World"
      And I follow "Thư Mời"
      And I select "Push The World" from "import_from"
      And I press "Thêm"
    Then I should see "Thêm liên lạc thành công."
      And I should see "Tu Hoang"
      And I should see "donor@mail.net"

  # Scenario: Add photo of new project update
  #   Given the date is 2013-09-11
  #     And there is a user with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass"
  #     And there is a project with the title "Push The World" and the description "test project update" and the start date "2013-09-22" and the end date "2013-09-30" and the funding goal "234234" and the location "HCM" and the status "REVIEWED" with the user above 
  #   When I login as "testing@man.net"
  #     And I go to the edit page of the project "Push The World"
  #     And I follow "Cập Nhật"
  #     And I attach the file "spec/files/image.jpg" to "project_update_photo"
  #     And I fill in "project_update_content" with "Test Content"
  #     And I press "Cập Nhật"
  #  Then I should see an element ".image_update"

  @javascript
  Scenario: Visit project page using token
    Given the date is 2013-09-11
      And there is a user with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass"
      And there is a project with the id "1" and the title "Push The World" and the description "test project update" and the start date "2013-09-22" and the end date "2013-09-30" and the funding goal "234234" and the location "HCM" and the status "REVIEWED" with the user above
      And there is a redirect token with the redirect class name "Project" and the redirect class id "1" and the value "123456"
    When a GET request is sent to "/fbnotif/123456"
    Then I should see "Push The World"
    When a GET request is sent to "/fbnotif/12345"
    Then I should see "Ủng hộ từ thiện chưa bao giờ dễ dàng đến vậy."

  Scenario: Add member
    Given the date is 2013-09-11
      And there is a user with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass"
      And there is a project with the title "Push The World" and the description "test project update" and the start date "2013-09-22" and the end date "2013-09-30" and the funding goal "234234" and the location "HCM" and the status "REVIEWED" with the user above 
    When I login as "testing@man.net"
      And I go to the dashboard of the project "Push The World"
      And I follow "Thành Viên"
      Then I should see "Thêm Thành Viên Mới"
    When I fill in "email" with "tu@charity-map.org"
      And I press "Thêm"
    Then I should see "Không tìm được tài khoản với email đã nhập."
    When there is a user with the email "tu@charity-map.org" and the password "secretpass" and the password confirmation "secretpass"
      And I fill in "email" with "tu@charity-map.org"
      And I press "Thêm"
      Then I should see "Thêm thành viên vào dự án thành công."
      Then I should see "(Xoá)"
    When I go to the project page of "Push The World"
    Then I should see "tu"
      And I should see "Thành Viên Dự Án"
      And I am not authenticated
      And I login as "tu@charity-map.org"
      Then an email should have been sent with:
        """
        From: team@charity-map.org
        To: tu@charity-map.org
        Subject: Bạn là thành viên mới của dự án Push The World
        """
      And "tu@charity-map.org" should receive an email
      When I open the email
      When I follow "đường dẫn này" in the email
      Then the URL should contain "dashboard?utm_campaign=EmailOnNewProjectMember&utm_medium=link&utm_source=email"
      And I follow "Push The World"
      And I follow "Thành Viên"
      Then I should not see "Thêm Thành Viên Mới"