Feature: Gift Card
  Scenario: To be created successfully
    Given there is a user with the full name "MixUP" and the email "mixup@gmail.com" and the password "secretpass" and the password confirmation "secretpass"
    When I login as "mixup@gmail.com"
      # And I go to the gift cards dashboard
      # And I follow "+ Tạo gift card"
      And I go to the create-new-card page
      And I fill in "gift_card_recipient_email" with "rebyn@me.com"
      And I fill in "gift_card_amount" with "100000"
      And I press "submit"
    Then an email should have been sent with:
      """
      From: team@charity-map.org
      To: rebyn@me.com
      Subject: Chúc mừng! Bạn vừa nhận được thẻ quà tặng từ MixUP
      """
    And "rebyn@me.com" should receive an email
    When I open the email
    Then I should see "Bạn vừa nhận được một gift card từ" in the email body
    When I follow "đường dẫn này" in the email
    Then the URL should contain "/gifts"