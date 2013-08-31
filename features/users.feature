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