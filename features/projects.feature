Feature: Project
  Scenario: To be displayed in a box
    Given there is a project with the title "Books from Heart" and the description "Giving away libraries for suburban schools." and the start date "#{Time.parse("2013-05-23")}" and the end date "#{Time.parse("2013-05-30")}" and the funding goal "5000000" and the location "Ho Chi Minh City" and the user id "1"
      And there is a user with the id "1" and the full name "Hoang Minh Tu" and the password "12345678" and the password confirmation "12345678"
    When I go to the home page
    Then I should see "Books from Heart"
      And I should see "Giving away libraries for suburban schools."
      And I should see "5000000"