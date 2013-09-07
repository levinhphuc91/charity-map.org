Feature: Donation

	Scenario: User without contact info to be asked to update
		Given the date is "2013-09-10"
			And there is a user with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass" and the full name "Vu Manh Cuong"
			And there is a project with the title "Push The World" and the description "test slug" and the start date "2013-09-11" and the end date "2013-09-14" and the funding goal "234234" and the location "HCM" and the status "REVIEWED" with the user above
	  	And there is a project reward with the amount "10000" and the description "reward description" with the project above
	 		And there is a user with the email "donor@man.net" and the password "secretpass" and the password confirmation "secretpass"
	 	Given the date is "2013-09-13"
	 	When I login as "donor@man.net"
		 	And I go to the project page of "Push The World"
	 		And I follow "Ủng Hộ"
	 	Then I should see "Vui lòng điền đầy đủ thông tin liên hệ trước khi ủng hộ dự án Push The World"
	 		And I fill in "Address" with "This is my address"
	 		And I fill in "Phone" with "+123456"
	 		And I press "Update User"
	 		And I go to the project page of "Push The World"
	 		And I follow "Ủng Hộ"
	 	Then I should see "Vu Manh Cuong"

	Scenario: Email with bank account info to be sent for Bank Transfer donations
		Given there is a user with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass" and the full name "Vu Manh Cuong"
			And there is a project with the title "Push The World" and the description "test slug" and the start date "2013-09-11" and the end date "2013-09-14" and the funding goal "234234" and the location "HCM" and the status "REVIEWED" with the user above
	  	And there is a project reward with the amount "10000" and the description "reward description" with the project above
	 		And there is a user with the email "donor@man.net" and the password "secretpass" and the password confirmation "secretpass"
	 	Given the date is "2013-09-13"
	 	When I login as "donor@man.net"
	 		And I go to the project page of "Push The World"
	 		And I follow "Ủng Hộ"
	 		And I fill in "Amount" with "12345"
	 		And I fill in "Note" with "Nothing"
	 		And I select "Chuyển khoản ngân hàng" from "Collection method"
	 		And I press "Tiếp Tục"
	 	# Then "donor@man.net" should receive an email with subject "Thông tin tài khoản NH đóng góp cho dự án Push The World"
	 	Then an email should have been sent with:
		  """
		  From: tu@charity-map.org
		  To: donor@man.net
		  """
		When I follow the first link in the email
		Then I should see "The project creator will check their bank statement and let you know soon."

	Scenario: Get a email to request verification
	  Given there is a project with the title "Push The World" and the id "1" and the user id "2" and the description "test slug" and the start date "2013-09-11" and the end date "2013-09-12" and the funding goal "234234" and the location "HCM" and the status "REVIEWED"
	  	And there is a project reward with the id "1" and the amount "12340" and the project id "1" and the description "reward description"
	  	And there is a user with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass"
	  	And there is a donation with the id "1" and the euid "12345" and the amount "12345" and the project id "1" and the status "PENDING" and the project reward id "1" and the collection_method "BANK_TRANSFER" with the user above
	 		And there is a user with the email "project_creator@man.net" and the password "secretpass" and the password confirmation "secretpass" and the id "2" and the full name "Vu Manh Cuong"
	 	When  I login as "testing@man.net"
	  	And I go to the dashboard
	  	And I follow "Request Verification"
	  Then  I should see "The project creator will check their bank statement and let you know soon."
	  Then  an email should have been sent with:
			"""
			From: tu@charity-map.org
			To: project_creator@man.net
			Subject: Confirm bank statement
			Body: Hello Vu Manh Cuong
						To confirm bank statement, just follow this link http://localhost:3000/dashboard/request_verification/euid/12345 
			"""