# TODO: revise test to reflect changes in homepage

Feature: Project
#   Scenario: To be displayed in a box
#     Given there is a project with the title "Books from Heart" and the description "Giving away libraries for suburban schools." and the start date "2013-05-23" and the end date "2013-05-30" and the funding goal "5000000" and the location "Ho Chi Minh City" and the user id "1" and the status "REVIEWED"
#       And there is a user with the id "1" and the full name "Hoang Minh Tu" and the password "12345678" and the password confirmation "12345678"
#       # TODO: change sentence to express association
#     When I go to the home page
#     Then I should see "Books from Heart"
#       And I should see "Giving away libraries for suburban schools."
#       And I should see "5000000"

  Scenario: To be created successfully
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

  Scenario: To be created unsuccessfully
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

  Scenario: To be given a slug
    Given there is a project with the title "Push The World" and the user id "1" and the description "test slug" and the start date "2013-09-11" and the end date "2013-09-12" and the funding goal "234234" and the location "HCM"
      And I am a new, authenticated user
    When I go to the project page of "Push The World"
    Then the URL should contain "push-the-world"

  Scenario: To be given an updated slug after edit
    Given there is a user with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass"
      And there is a project with the title "Push The World" and the user id "1" and the description "test slug" and the start date "2013-09-11" and the end date "2013-09-12" and the funding goal "234234" and the location "HCM" with the user above
    When I go to the login page
      And I fill in "Email" with "testing@man.net"
      And I fill in "Password" with "secretpass"
      And I press "Sign in"
      And I go to the project page of "Push The World"
      And I follow "Edit"
      And I fill in "Title" with "Kick The School"
      And I press "Create Project"
      And I go to the project page of "Kick The School"
      Then the URL should contain "kick-the-school"

  Scenario: To be submitted for review
    Given there is a user with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass"
      And there is a project with the title "Push The World" and the user id "1" and the description "test slug" and the start date "2013-09-11" and the end date "2013-09-12" and the funding goal "234234" and the location "HCM" with the user above
    When I go to the login page
      And I fill in "Email" with "testing@man.net"
      And I fill in "Password" with "secretpass"
      And I press "Sign in"
      And I go to the dashboard
      And I follow "Chỉnh Sửa"
      And I follow "Gui xet duyet"
      And show me the page
    When I go to the project page of "Push The World"
    Then I should see "Project has been submitted. We'll keel you in touch."