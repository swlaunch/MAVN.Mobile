Feature: Login
  Login scenarios

  Scenario: Successful login
    Given I navigate to the page "LoginPage"
    And user "valid@email.com" exists for login
    When I fill the "emailTextField" field with "valid@email.com"
    And I fill the "passwordTextField" field with "validPassword"
    And "loginSubmitButton" is scrolled into view
    And I tap the "loginSubmitButton" button
    Then I am on the page "HomePage"

  Scenario: Unsuccessful login - Invalid credentials
    Given I navigate to the page "LoginPage"
    And user "valid@email.com" does not exist for login
    When I fill the "emailTextField" field with "valid@email.com"
    And I fill the "passwordTextField" field with "validPassword"
    And "loginSubmitButton" is scrolled into view
    And I tap the "loginSubmitButton" button
    Then I am on the page "LoginPage"
    And I expect the "loginError" to be "Your login details are incorrect. Please try again."

  Scenario: Unsuccessful login - Backend Invalid email format
    Given I navigate to the page "LoginPage"
    And email "invalid@email.com" has invalid format for login
    When I fill the "emailTextField" field with "invalid@email.com"
    And I fill the "passwordTextField" field with "validPassword"
    And "loginSubmitButton" is scrolled into view
    And I tap the "loginSubmitButton" button
    Then I am on the page "LoginPage"
    And I expect the "loginError" to be "Your login details are incorrect. Please try again."

  Scenario: Unsuccessful login - Backend Invalid password format
    Given I navigate to the page "LoginPage"
    And password "invalidPassword" has invalid format for login
    When I fill the "emailTextField" field with "valid@email.com"
    And I fill the "passwordTextField" field with "invalidPassword"
    And "loginSubmitButton" is scrolled into view
    And I tap the "loginSubmitButton" button
    Then I am on the page "LoginPage"
    And I expect the "loginError" to be "Your login details are incorrect. Please try again."

  Scenario: Unsuccessful login - Response timeout
    Given I navigate to the page "LoginPage"
    And the login request will timeout
    When I fill the "emailTextField" field with "valid@email.com"
    And I fill the "passwordTextField" field with "validPassword"
    And "loginSubmitButton" is scrolled into view
    And I tap the "loginSubmitButton" button
    Then I am on the page "LoginPage"
    Then I expect the "loginError" to be "Looks like you are not connected to the Internet, please check your connection and try again."

  Scenario: Unsuccessful login - Connection timeout
    Given I navigate to the page "LoginPage"
    And the service is unavailable
    When I fill the "emailTextField" field with "valid@email.com"
    And I fill the "passwordTextField" field with "validPassword"
    And "loginSubmitButton" is scrolled into view
    And I tap the "loginSubmitButton" button
    Then I am on the page "LoginPage"
    Then I expect the "loginError" to be "Looks like you are not connected to the Internet, please check your connection and try again."

  Scenario: Invalid email and password - Client side validation errors
    Given I navigate to the page "LoginPage"
    When I fill the "emailTextField" field with "client.side.invalid.email"
    And I fill the "passwordTextField" field with "invp"
    And "loginSubmitButton" is scrolled into view
    And I tap the "loginSubmitButton" button
    Then I am on the page "LoginPage"
    Then I expect the text "Please enter a valid email" to be present
    Then I expect the text "The password should be at least 8 characters long containing one upper case, one number and one special sign (!@#\$%&)." to not be present

  Scenario: Empty email and password - Client side validation errors
    Given I navigate to the page "LoginPage"
    And "loginSubmitButton" is scrolled into view
    When I tap the "loginSubmitButton" button
    Then I am on the page "LoginPage"
    Then I expect the text "Email is required" to be present
    Then I expect the text "Password is required" to be present