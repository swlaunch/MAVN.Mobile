Feature: Balance
  Balance scenarios

  Scenario: Show balance - Success
    Given I have a balance
    And I am logged in
    When I navigate to the page "HomePage"
    Then I expect the "balanceText" to be "123 ABC"

  Scenario: Show balance - Token expired
    Given token expired for balance request
    And I am logged in
    When I navigate to the page "HomePage"
    Then I am on the page "LoginPage"
    And I expect the "unauthorizedRedirectionMessage" to be "Your session has expired, please login again"

  Scenario: Show balance - Response timeout
    Given the balance request will timeout
    And I am logged in
    When I navigate to the page "HomePage"
    Then I expect the "errorWidgetIconDetails" to be "Sorry, we are unable to show your balance."

  Scenario: Navigate to the LeadReferralPage
    Given I am logged in
    When I tap the "goToLeadReferralPageButton" button
    Then I am on the page "LeadReferralPage"


#  Todo: Untestable scenario, because the balance request happens immediately after the
#  login request, and we don't have a good way to close the mock server between the requests
#  Scenario: Show balance - Connection timeout
#    Given I am logged in
#    And the service is unavailable
#    When I navigate to the page "HomePage"
#    Then I expect the "showBalanceError" to be "There was a problem connecting to the service."
