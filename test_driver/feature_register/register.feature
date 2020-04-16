Feature: Register
  Register scenarios

  Scenario: Successful register
    Given I navigate to the page "RegisterPage"
    And user "valid@email.com" is available for register
    When I fill the "emailTextField" field with "valid@email.com"
    And I fill the "passwordTextField" field with "validPassword"
    And "registerSubmitButton" is scrolled into view
    And I tap the "registerSubmitButton" button
    Then I am on the page "RegisterSuccessPage"

  Scenario: Navigate to the Login page after a successful register
    Given I successfully registered a new account
    And I am on the page "RegisterSuccessPage"
    When I tap the "goToLoginPageButton" button
    Then I am on the page "LoginPage"

  Scenario: Unsuccessful register - Login already in use
    Given I navigate to the page "RegisterPage"
    And user "valid@email.com" already exists for register
    When I fill the "emailTextField" field with "valid@email.com"
    And I fill the "passwordTextField" field with "validPassword"
    And "registerSubmitButton" is scrolled into view
    And I tap the "registerSubmitButton" button
    Then I am on the page "RegisterPage"
    And I expect the "registerError" to be "Login already in use"

  Scenario: Unsuccessful register - Backend Invalid email format
    Given I navigate to the page "RegisterPage"
    And email "backend.invalid@email.com" has invalid format for register
    When I fill the "emailTextField" field with "backend.invalid@email.com"
    And I fill the "passwordTextField" field with "validPassword"
    And "registerSubmitButton" is scrolled into view
    And I tap the "registerSubmitButton" button
    Then I am on the page "RegisterPage"
    And I expect the "registerError" to be "Invalid email"

  Scenario: Unsuccessful register - Backend Invalid password format
    Given I navigate to the page "RegisterPage"
    And password "invalidPassword" has invalid format for register
    When I fill the "emailTextField" field with "valid@email.com"
    And I fill the "passwordTextField" field with "invalidPassword"
    And "registerSubmitButton" is scrolled into view
    And I tap the "registerSubmitButton" button
    Then I am on the page "RegisterPage"
    And I expect the "registerError" to be "Invalid password"

  Scenario: Unsuccessful register - Response timeout
    Given I navigate to the page "RegisterPage"
    And the register request will timeout
    When I fill the "emailTextField" field with "valid@email.com"
    And I fill the "passwordTextField" field with "validPassword"
    And "registerSubmitButton" is scrolled into view
    And I tap the "registerSubmitButton" button
    Then I am on the page "RegisterPage"
    Then I expect the "registerError" to be "Looks like you are not connected to the Internet, please check your connection and try again."

  Scenario: Unsuccessful register - Connection timeout
    Given I navigate to the page "RegisterPage"
    And the service is unavailable
    When I fill the "emailTextField" field with "valid@email.com"
    And I fill the "passwordTextField" field with "validPassword"
    And "registerSubmitButton" is scrolled into view
    And I tap the "registerSubmitButton" button
    Then I am on the page "RegisterPage"
    Then I expect the "registerError" to be "Looks like you are not connected to the Internet, please check your connection and try again."

  Scenario: Invalid email and password - Client side validation errors
    Given I navigate to the page "RegisterPage"
    When I fill the "emailTextField" field with "client.side.invalid.email"
    And I fill the "passwordTextField" field with "invp"
    And "registerSubmitButton" is scrolled into view
    And I tap the "registerSubmitButton" button
    Then I am on the page "RegisterPage"
    Then I expect the text "Please enter a valid email" to be present
    Then I expect the text "The password should be at least 8 characters long containing one upper case, one number and one special sign (!@#\$%&)." to be present

  Scenario: Empty email and password - Client side validation errors
    Given I navigate to the page "RegisterPage"
    When I tap the "registerSubmitButton" button
    Then I am on the page "RegisterPage"
    Then I expect the text "Email is required" to be present
    Then I expect the text "Password is required" to be present