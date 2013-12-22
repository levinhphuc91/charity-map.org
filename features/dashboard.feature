Feature: Dashboard

  Scenario: For new users
    Given there is a user with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass"
      And I login as "testing@man.net"
    When I go to the dashboard
    Then I should see "Tạo Dự Án Mới" within ".dashboard--sidebar"

  Scenario: Asks USER to request verification for bank transfer donations
    # Given there is a user with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass"
    #   And there is a project with the title "Push The World" and the description "test project update" and the start date "2013-09-22" and the end date "2013-09-30" and the funding goal "234234" and the location "HCM" and the status "REVIEWED" with the user above
    #   And there is a project reward with the value "100000" and the description "Test Note" with the project above
    #   And there is a donation with the amount "100000" and the note "Bank Transfer" and the collection method "BANK_TRANSFER" with the user above and with the project above
    # When I login as "testing@man.net"