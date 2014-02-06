Feature: Donation

	Scenario: User without contact info to be asked to update
		Given the date is "2013-09-10"
			And there is a user with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass" and the full name "Vu Manh Cuong"
			And there is a project with the title "Push The World" and the description "test slug" and the start date "2013-09-11" and the end date "2013-09-14" and the funding goal "234234" and the location "HCM" and the status "REVIEWED" with the user above
	  	And there is a project reward with the value "10000" and the description "reward description" with the project above
	 		And there is a user with the email "donor@man.net" and the password "secretpass" and the password confirmation "secretpass" and the phone "12345678"
	 	Given the date is "2013-09-13"
	 	When I login as "donor@man.net"
		 	And I go to the project page of "Push The World"
	 		And I follow "ủng hộ dự án"
	 	Then I should see "Vui lòng điền đầy đủ thông tin cá nhân để ủng hộ dự án Push The World (họ và tên, địa chỉ, số điện thoại)."
	 		And I fill in "Họ và Tên*" with "Hoang Minh Tus"
	 		And I fill in "Địa chỉ*" with "This is my address"
	 		And I fill in "Số ĐT*" with "+123456"
	 		And I press "Cập nhật Thông Tin"
	 	Then I should see "Cập nhật thành công."
	 		And I should see "Các Câu Hỏi Thường Gặp"

	Scenario: Email with bank account info to be sent for Bank Transfer donations
		Given the date is "2013-09-10"
			And there is a user with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass" and the full name "Vu Manh Cuong"
			And there is a project with the title "Push The World" and the description "test slug" and the start date "2013-09-11" and the end date "2013-09-14" and the funding goal "234234" and the location "HCM" and the status "REVIEWED" and the bank info "Techcombank" with the user above
	  	And there is a project reward with the value "10000" and the description "reward description" with the project above
	 		And there is a user with the email "donor@man.net" and the password "secretpass" and the password confirmation "secretpass" and the full name "Nguoi Ung Ho" and the address "HCM" and the city "HCM" and the phone "123456"
	 	Given the date is "2013-09-13"
	 	When I login as "donor@man.net"
	 		And I go to the project page of "Push The World"
	 		And I follow "ủng hộ dự án"
	 		And I fill in "donation_amount" with "12345"
	 		And I fill in "donation_note" with "Nothing"
	 		And I select "Chuyển khoản ngân hàng" from "donation_collection_method"
	 		And I press "Ủng Hộ Push The World"
	 	Then an email should have been sent with:
		  """
		  From: team@charity-map.org
		  To: donor@man.net
		  """
			And I should see "Techcombank" in the email
			And "donor@man.net" should receive an email
			And I open the email
			And I follow "đường dẫn này" in the email
		Then I should see "Yêu cầu tra soát hệ thống đã được gửi. Chúng tôi sẽ liên lạc trong thời gian sớm nhất."
			And an email should have been sent with:
			  """
			  From: team@charity-map.org
			  To: testing@man.net
			  """
			 And "testing@man.net" should receive an email
			And I open the email
			And I follow "đường dẫn này" in the email
		Then the URL should contain "projects/push-the-world/donations"

	Scenario: Request verification for bank transfer on dashboard
	  Given the date is 2013-09-11
	  	And there is a user with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass"
	  	And there is a project with the title "Push The World" and the description "test slug" and the start date "2013-09-11" and the end date "2013-09-13" and the funding goal "234234" and the location "HCM" and the status "REVIEWED" with the user above
	  	And there is a project reward with the value "12340" the description "reward description" with the project above
	  	And there is a user with the email "donor@man.net" and the password "secretpass" and the password confirmation "secretpass" and the full name "Nguoi Ung Ho" and the address "HCM" and the city "HCM" and the phone "123456"
  	Given the date is "2013-09-12"
	 	When I login as "donor@man.net"
	 		And I go to the project page of "Push The World"
	 		And I follow "ủng hộ dự án"
	 		And I fill in "donation_amount" with "12345"
	 		And I fill in "donation_note" with "Nothing"
	 		And I select "Chuyển khoản ngân hàng" from "donation_collection_method"
	 		And I press "Ủng Hộ Push The World"
	 	Then I should see "Cảm ơn bạn đã ủng hộ dự án! Vui lòng check email để nhận thông tin tài khoản ngân hàng để tiến hành chuyển khoản."
	 	Then "donor@man.net" should receive an email
		When I open the email
			And I follow "đường dẫn này" in the email
		Then I should see "Yêu cầu tra soát hệ thống đã được gửi. Chúng tôi sẽ liên lạc trong thời gian sớm nhất."
	  When I am not authenticated
		  And I login as "testing@man.net"
	  	And "testing@man.net" should receive an email
			And I open the email
			And I follow "đường dẫn này" in the email
      And I follow "Xác nhận ủng hộ"
		Then I should see "Xác nhận thành công. Email vừa được gửi tới mạnh thường quân thông báo bạn đã nhận được tiền."
			And an email should have been sent with:
			  """
			  From: team@charity-map.org
			  To: donor@man.net
			  Subject: Xác nhận giao dịch CKNH thành công, dự án Push The World
			  """
		When I get redirected via the last redirect token
    Then the URL should contain "/projects/push-the-world/donations?utm_campaign=NotifOnDonation"

	Scenario: Donation list for normal user
		Given the date is 2013-09-11
	  	And there is a user with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass"
	  	And there is a project with the title "Push The World" and the description "test slug" and the start date "2013-09-11" and the end date "2013-09-13" and the funding goal "234234" and the location "HCM" and the status "REVIEWED" with the user above
	  	And there is a project reward with the value "10000" and the description "reward description" with the project above
	  	And there is a donation with the amount "10000" and the status "SUCCESSFUL" and the collection method "BANK_TRANSFER" with the user above and the project above and the project reward above
	 		And there is a donation with the amount "12666" and the status "PENDING" and the collection method "COD" with the user above and the project above and the project reward above
	 	When I go to the donation page of the project "Push The World"
 		Then I should see "testing ủng hộ 10.000 VNĐ"
	 		And I should not see "12.666 VNĐ"

	Scenario: Donation list for project creator
		Given the date is 2013-09-11
	  	And there is a user with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass"
	  	And there is a project with the title "Push The World" and the description "test slug" and the start date "2013-09-11" and the end date "2013-09-13" and the funding goal "234234" and the location "HCM" and the status "REVIEWED" with the user above
	  	And there is a user with the email "donor@man.net" and the password "secretpass" and the password confirmation "secretpass" and the full name "Nguoi Ung Ho" and the address "HCM" and the city "HCM" and the phone "123456"
	  	And there is a project reward with the value "10000" and the description "reward description" with the project above
	  	And there is a donation with the amount "10000" and the status "SUCCESSFUL" and the collection method "BANK_TRANSFER" with the user above and the project above and the project reward above
	  	And there is a donation with the amount "11000" and the status "PENDING" and the collection method "BANK_TRANSFER" with the user above and the project above and the project reward above
	  	And there is a donation with the amount "21000" and the status "REQUEST_VERIFICATION" and the collection method "BANK_TRANSFER" with the user above and the project above and the project reward above
	 		And there is a donation with the amount "12666" and the status "PENDING" and the collection method "COD" with the user above and the project above and the project reward above
	 	When I login as "testing@man.net"
	 	Then I go to the donation page of the project "Push The World"
	 		And I should see "Chuyển Khoản Ngân Hàng"
	 		And I should see "10.000 VNĐ"
	 		# And I should see "Thành Công"
	 		And I should see "Chuyển Khoản Ngân Hàng"
	 		And I should see "11.000 VNĐ"
	 		# And I should see "Chờ CK"
	 		And I should see "12.666 VNĐ"
	 		# And I should see "Đợi Xác Nhận"
	 		And I should see "Xác nhận ủng hộ"
	 		And I should see "Thu Tiền Tận Nơi"
	 		And I should see "12.666 VNĐ"
	 		# And I should see "Đợi Liên Hệ"
	 		
	Scenario: Donation list for CM staff
		Given the date is 2013-09-11
	  	And there is a user with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass"
	  	And there is a project with the title "Push The World" and the description "test slug" and the start date "2013-09-11" and the end date "2013-09-13" and the funding goal "234234" and the location "HCM" and the status "REVIEWED" with the user above
	  	And there is a project reward with the value "10000" and the description "reward description" with the project above
	  	And there is a donation with the amount "10000" and the status "SUCCESSFUL" and the collection method "BANK_TRANSFER" with the user above and the project above and the project reward above
	 		And there is a donation with the amount "12666" and the status "PENDING" and the collection method "COD" with the user above and the project above and the project reward above
	 		And there is a donation with the amount "21000" and the status "REQUEST_VERIFICATION" and the collection method "BANK_TRANSFER" with the user above and the project above and the project reward above
	 		And there is a user with the email "staff@man.net" and the password "secretpass" and the password confirmation "secretpass" and the staff "1"
	 	When I login as "staff@man.net"
	 	Then I go to the donation page of the project "Push The World"
	 		And I should see "Chuyển Khoản Ngân Hàng"
	 		And I should see "10.000 VNĐ"
	 		# And I should see "Thành Công"
	 		And I should see "Thu Tiền Tận Nơi"
	 		And I should see "12.666 VNĐ"
	 		# And I should see "Đợi Liên Hệ"
	 		And I should see "Xác nhận ủng hộ"
	 		# And I should not see "Chờ CK"

	Scenario: Confirm bank-transfer donations
	  Given the date is 2013-09-11
	  	And there is a user with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass"
	  	And there is a project with the title "Push The World" and the description "test slug" and the start date "2013-09-11" and the end date "2013-09-13" and the funding goal "234234" and the location "HCM" and the status "REVIEWED" with the user above
	  	And there is a project reward with the value "12340" the description "reward description" with the project above
	  	And there is a user with the email "donor@man.net" and the password "secretpass" and the password confirmation "secretpass" and the full name "Nguoi Ung Ho" and the address "HCM" and the city "HCM" and the phone "123456"
	  	And there is a donation with the status "REQUEST_VERIFICATION" and the amount "12340" with the collection method "BANK_TRANSFER" with the project above and with the user above and with the project reward above
  	Given the date is "2013-09-12"
	 	When I login as "testing@man.net"
	  	And I go to the donation page of the project "Push The World"
  		And I follow "Xác nhận ủng hộ"
	  Then  I should see "Xác nhận thành công. Email vừa được gửi tới mạnh thường quân thông báo bạn đã nhận được tiền."
	  Then  an email should have been sent with:
			"""
			From: team@charity-map.org
			To: donor@man.net
			Subject: Xác nhận giao dịch CKNH thành công, dự án Push The World
			"""
		When I get redirected via the last redirect token
    Then the URL should contain "/projects/push-the-world/donations?utm_campaign=NotifOnDonation"

	Scenario: Confirm COD donations
	  Given the date is 2013-09-11
	  	And there is a user with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass"
	  	And there is a project with the title "Push The World" and the description "test slug" and the start date "2013-09-11" and the end date "2013-09-13" and the funding goal "234234" and the location "HCM" and the status "REVIEWED" with the user above
	  	And there is a project reward with the value "12340" the description "reward description" with the project above
	  	And there is a user with the email "donor@man.net" and the password "secretpass" and the password confirmation "secretpass" and the full name "Nguoi Ung Ho" and the address "HCM" and the city "HCM" and the phone "123456"
	  	And there is a donation with the status "PENDING" and the amount "12340" with the collection method "COD" with the project above and with the user above and with the project reward above
  	Given the date is "2013-09-12"
	 	When I login as "testing@man.net"
	  	And I go to the donation page of the project "Push The World"
  		And I follow "Xác nhận ủng hộ"
	  Then  I should see "Xác nhận thành công. Email vừa được gửi tới mạnh thường quân thông báo bạn đã nhận được tiền."
	  Then  an email should have been sent with:
			"""
			From: team@charity-map.org
			To: donor@man.net
			Subject: Xác nhận đã nhận tiền mặt ủng hộ dự án Push The World
			"""
		When I get redirected via the last redirect token
    Then the URL should contain "/projects/push-the-world/donations?utm_campaign=NotifOnDonation"

	Scenario: Convert ExtDonation to Donation
		Given the date is 2013-09-11
      And there is a user with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass"
      And there is a project with the title "Push The World" and the description "test project update" and the start date "2013-09-22" and the end date "2013-09-30" and the funding goal "234234" and the location "HCM" and the status "REVIEWED" with the user above 
      And there is a project reward with the value "15000" and the description "Bla Bla Bla" with the project above
    When I login as "testing@man.net"
      And I go to the dashboard of the project "Push The World"
      And I follow "Thống Kê Đóng Góp"
      Then I should see "Thêm Ủng Hộ Ngoài Hệ Thống"
    When I fill in "ext_donation_donor" with "Tu Hoang"
      And I fill in "ext_donation_amount" with "100000"
      And I fill in "ext_donation_collection_time" with "25/09/2013"
      And I fill in "ext_donation_email" with "donor@mail.net"
      And I press "Thêm"
    Then I should see "Thêm ủng hộ ngoài hệ thống thành công."
    Then an email should have been sent with:
      """
      From: team@charity-map.org
      To: donor@mail.net
      Subject: Cảm ơn bạn đã ủng hộ dự án Push The World
      """
    	And "donor@mail.net" should receive an email
    When I open the email
    Then I should see "đường dẫn này" in the email body
    When I follow "đường dẫn này" in the email
    Then I should not see "Cảm ơn Tu Hoang"
    And I am not authenticated
      When I follow "đường dẫn này" in the email
      Then I should see "Cảm ơn Tu Hoang"
      And I should see "hoặc đăng ký bằng email"
      And I follow "bằng email"
    	And I should see "donor@mail.net" in the "user_email" input
    	And I fill in "user_password" with "12345678"
    	And I fill in "user_password_confirmation" with "12345678"
    And I press "Đăng Ký"
    Then I should see "Xin chào! Bạn đã đăng ký thành công."
    	And I follow "Quản Lý"
    	And I follow "Trang Cá Nhân"
    Then I should see "ủng hộ 100.000 VNĐ (Chuyển Khoản Ngân Hàng)"
    # Case: Token being used for more than one time
    When I am not authenticated
    And I open the email
    Then I should see "đường dẫn này" in the email body
    When I follow "đường dẫn này" in the email
      And I follow "bằng email"
      And I should not see "donor@mail.net" in the "user_email" input
      And I fill in "user_email" with "stranger_email_who_tries_to_use_the_token@gmail.com"
      And I fill in "user_password" with "12345678"
      And I fill in "user_password_confirmation" with "12345678"
    And I press "Đăng Ký"
    Then I should see "Xin chào! Bạn đã đăng ký thành công."
      And I follow "Quản Lý"
      And I follow "Trang Cá Nhân"
    Then I should not see "ủng hộ 100.000 VNĐ (Chuyển Khoản Ngân Hàng)"

  Scenario: Convert ExtDonation to Donation (logging via Facebook)
    Given the date is 2013-09-11
      And there is a user with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass"
      And there is a project with the title "Push The World" and the description "test project update" and the start date "2013-09-22" and the end date "2013-09-30" and the funding goal "234234" and the location "HCM" and the status "REVIEWED" with the user above 
      And there is a project reward with the value "15000" and the description "Bla Bla Bla" with the project above
    When I login as "testing@man.net"
      And I go to the dashboard of the project "Push The World"
      And I follow "Thống Kê Đóng Góp"
      Then I should see "Thêm Ủng Hộ Ngoài Hệ Thống"
    When I fill in "ext_donation_donor" with "Tu Hoang"
      And I fill in "ext_donation_amount" with "100000"
      And I fill in "ext_donation_collection_time" with "25/09/2013"
      And I fill in "ext_donation_email" with "user@man.net"
      And I press "Thêm"
    Then I should see "Thêm ủng hộ ngoài hệ thống thành công."
    And I should see "Tu Hoang ủng hộ 100.000 VNĐ"
    Then an email should have been sent with:
      """
      From: team@charity-map.org
      To: user@man.net
      Subject: Cảm ơn bạn đã ủng hộ dự án Push The World
      """
      And "user@man.net" should receive an email
      And I am not authenticated
    When I open the email
    Then I should see "đường dẫn này" in the email body
    When I follow "đường dẫn này" in the email
    Then I should see "Push The World"
      And I should see "Cảm ơn Tu Hoang"
    When Facebook login is mocked
    And I follow "Đăng Ký Bằng Facebook"
    Then I should see "Đăng nhập thành công bằng tài khoản Facebook."
      And I follow "Quản Lý"
      And I follow "Trang Cá Nhân"
    Then I should see "ủng hộ 100.000 VNĐ (Chuyển Khoản Ngân Hàng)"
    Given I am not authenticated
    When I login as "testing@man.net"
    When I go to the dashboard of the project "Push The World"
      And I follow "Thống Kê Đóng Góp"
    Then I should not see "Tu Hoang ủng hộ 100.000 VNĐ"

	Scenario: Add ExtDonation 
		Given the date is 2013-09-11
      And there is a user with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass"
      And there is a project with the title "Push The World" and the description "test project update" and the start date "2013-09-22" and the end date "2013-09-30" and the funding goal "234234" and the location "HCM" and the status "REVIEWED" with the user above 
      And there is a project reward with the value "15000" and the description "Bla Bla Bla" with the project above
    When I login as "testing@man.net"
      And I go to the dashboard of the project "Push The World"
      And I follow "Thống Kê Đóng Góp"
      Then I should see "Thêm Ủng Hộ Ngoài Hệ Thống"
    When I fill in "ext_donation_donor" with "Tu Hoang"
      And I fill in "ext_donation_amount" with "100000"
      And I fill in "ext_donation_collection_time" with "25/09/2013"
      And I fill in "ext_donation_email" with "donor@mail.net"
      And I press "Thêm"
    Then I should see "Thêm ủng hộ ngoài hệ thống thành công."
      Then an email should have been sent with:
        """
        From: team@charity-map.org
        To: donor@mail.net
        Subject: Cảm ơn bạn đã ủng hộ dự án Push The World
        """
    	And I should see "Tu Hoang ủng hộ 100.000 VNĐ"
    When I follow "Sửa"
    	And I fill in "ext_donation_amount" with "200000"
    	And I press "Thêm"
    Then I should see "Tu Hoang ủng hộ 200.000 VNĐ"

  Scenario: Add ExtDonation (without sending notification)
    Given the date is 2013-09-11
      And there is a user with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass"
      And there is a project with the title "Push The World" and the description "test project update" and the start date "2013-09-22" and the end date "2013-09-30" and the funding goal "234234" and the location "HCM" and the status "REVIEWED" with the user above 
      And there is a project reward with the value "15000" and the description "Bla Bla Bla" with the project above
    When I login as "testing@man.net"
      And I go to the dashboard of the project "Push The World"
      And I follow "Thống Kê Đóng Góp"
      Then I should see "Thêm Ủng Hộ Ngoài Hệ Thống"
    When I fill in "ext_donation_donor" with "Tu Hoang"
      And I fill in "ext_donation_amount" with "100000"
      And I fill in "ext_donation_collection_time" with "25/09/2013"
      And I fill in "ext_donation_email" with "donor@mail.net"
      And I uncheck "notification"
      And I press "Thêm"
      And I fill in "ext_donation_donor" with "Donor without Email"
      And I fill in "ext_donation_amount" with "200000"
      And I fill in "ext_donation_collection_time" with "25/09/2013"
      And I press "Thêm"
    Then I should see "Thêm ủng hộ ngoài hệ thống thành công."
      And no email should have been sent
    # Try sending updates to ExtDonation
    When I go to the dashboard of the project "Push The World"
      And I follow "Cập Nhật"
      And I fill in "Tên cập nhật" with "Test Update Title"
      And I fill in "Nội dung cập nhật" with "Test Update Content"
      And I press "Cập Nhật"
    Then I should see "Vừa thêm Cập nhật dự án mới."
      And an email should have been sent with:
        """
        From: team@charity-map.org
        To: donor@mail.net
        Subject: Cập nhật mới từ dự án Push The World
        """

  Scenario: Add ExtDonation using a system email
    Given the date is 2013-09-11
      And there is a user with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass"
      And there is a project with the title "Push The World" and the description "test project update" and the start date "2013-09-22" and the end date "2013-09-30" and the funding goal "234234" and the location "HCM" and the status "REVIEWED" with the user above 
      And there is a project reward with the value "15000" and the description "Bla Bla Bla" with the project above
    When I login as "testing@man.net"
      And I go to the dashboard of the project "Push The World"
      And I follow "Thống Kê Đóng Góp"
      Then I should see "Thêm Ủng Hộ Ngoài Hệ Thống"
    When I fill in "ext_donation_donor" with "Tu Hoang"
      And I fill in "ext_donation_amount" with "100000"
      And I fill in "ext_donation_collection_time" with "25/09/2013"
      And I fill in "ext_donation_email" with "testing@man.net"
      And I uncheck "notification"
      And I press "Thêm"
    Then I should see "Email đã được đăng ký thành viên trên Charity Map. Vui lòng liên hệ MTQ để tiến hành ủng hộ qua hệ thống."