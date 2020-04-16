Feature: Welcome
  Welcome scenarios

  Scenario: I am redirected to login
    Given I navigate to the page "WelcomePage"
    And I tap the "welcomeSignInButton" button
    Then I am on the page "LoginPage"