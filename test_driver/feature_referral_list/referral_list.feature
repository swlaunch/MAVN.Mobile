Feature: Referral list
  Referral list scenarios

  Scenario: Show referral list - Success
    Given I am logged in
    And I have some referrals
    When I navigate to the page "ReferralListPage"
    Then I expect the widget with key "referralList" to be present

  Scenario: Show referral list - Token expired
    Given I am logged in
    And token expired for the get referral list request
    When I navigate to the page "ReferralListPage"
    Then I am on the page "LoginPage"
    And I expect the "unauthorizedRedirectionMessage" to be "Your session has expired, please login again"

  Scenario: Show referral list - Response timeout
    Given I am logged in
    And the get referral list request will timeout
    When I navigate to the page "ReferralListPage"
    Then I expect the "referralListError" to be "Looks like you are not connected to the Internet, please check your connection and try again."

  Scenario: Show referral list - Connection timeout
    Given I am logged in
    And the service is unavailable
    When I navigate to the page "ReferralListPage"
    Then I expect the "referralListError" to be "Looks like you are not connected to the Internet, please check your connection and try again."
