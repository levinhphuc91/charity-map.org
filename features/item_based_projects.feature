@api-call
Feature: Item-based Project
  Scenario: To be created and updated successfully
    When I create an item based project named "Push The World"
    Then I should see "Push The World"
      And the URL should contain "projects/push-the-world"
    When I start fundraising for project "Push The World"
    Then I should see "Dự án chuyển sang trạng thái gây quỹ."

  Scenario: To receive donations
    When I create an item based project named "Push The World"
      And I start fundraising for project "Push The World"
      And I am not authenticated
      And there is a user with the email "me@individual.net" and the password "secretpass" and the password confirmation "secretpass" and the full name "Potential Donor" and the address "HCM" and the city "HCM" and the phone "123456788"
      And I login as "me@individual.net"
      And I go to the project page of "Push The World"
      And I follow "150.000đ ⋅ ỦNG HỘ"
      And I should see "Tặng Phẩm"
      And I should see "Potential Donor / HCM / 123456788"
      And I press "Ủng Hộ Push The World"
    Then I should see "Cảm ơn bạn đã ủng hộ dự án! Chúng tôi sẽ liên hệ trong 3 ngày làm việc."

  Scenario: To receive donations using credit
    When I create an item based project named "Push The World"
      And I start fundraising for project "Push The World"
      And I am not authenticated
      And "me@individual.net" receives a credit of "100000"
      And I go to the project page of "Push The World"
      And I follow "150.000đ ⋅ ỦNG HỘ"
      And I complete my profile update
      Then the URL should contain "project_reward_id"
      And I should see "Tặng Phẩm"
      And I should see "Nguoi Ung Ho / Ho Chi Minh / 0903011591"
      And I select "Tài khoản charity-map.org (còn 100.000đ)" from "donation_collection_method"
      And I press "Ủng Hộ Push The World"
    Then I should see "Hiện tài khoản của bạn không đủ số tiền mà bạn muốn ủng hộ."
      And I follow "75.000đ ⋅ ỦNG HỘ"
      And I select "Tài khoản charity-map.org (còn 100.000đ)" from "donation_collection_method"
      And I press "Ủng Hộ Push The World"
    Then I should see "Cảm ơn bạn đã ủng hộ dự án! Vui lòng kiểm tra hòm thư để nhận email xác nhận."