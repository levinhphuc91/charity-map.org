Feature: User
  Scenario: Update their profile settings
    Given I am a new, authenticated user
      And I am on the users settings page
      And I fill in "Email" with "saidrebyn@gmail.com"
      And I fill in "Full name" with "Hoang Minh Tu"
      And I fill in "Address" with "10.5B D5 Binh Thanh"
      And I fill in "City" with "Ho Chi Minh"
      # TODO: Revise input field to be a dropdown list
      # And I select "Ho Chi Minh" in "City"
      And I fill in "Bio" with "Charity Map co-founders"
      And I fill in "Phone" with "0908 230 591"
      And I press "Update"
    Then I should see "Updated Successfully."

  Scenario: Visit dashboard, as a backer, without donations 
    Given I am a new, authenticated user
    When I go to the dashboard
    Then I should see "No statistics about your donation history yet."

  Scenario: Visit dashboard, as a backer having donations 
    Given there is a user with the email "vumanhcuong01@gmail.com" and the id "1" and the password "12345678" and the password confirmation "12345678"
      And there is a project with the title "Books from Heart" and the description "Giving away libraries for suburban schools." and the start date "2013-05-23" and the end date "2013-05-30" and the funding goal "5000000" and the location "Ho Chi Minh City" and the user id "1"
      And there is a donation with the user id "1" and the project id "1" and the amount "500000" and the collection method "COD"
    When I go to the login page
      And I fill in "Email" with "vumanhcuong01@gmail.com"
      And I fill in "Password" with "12345678"
      And I press "Sign in"
    When I go to the dashboard
    Then I should see "500000"
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
      And I should see "5000000"
      And I should see "50"
      And I should see "2"