Feature: P2P Transactions
  P2P Transactions scenarios

  Scenario: Successful transaction submission
    Given I have a balance
    Given I am logged in
    And I navigate to the page "TransactionFormPage"
    And transaction submission will be successful
    And I fill all transaction form data correctly
    When I tap the "transactionFormSendButton" button
    Then I am on the page "TransactionSuccessPage"

  Scenario: Transaction submission error
    Given I have a balance
    Given I am logged in
    And I navigate to the page "TransactionFormPage"
    And transaction submission will return an error
    And I fill all transaction form data correctly
    When I tap the "transactionFormSendButton" button
    Then I expect the "errorWidgetDetails" to be "Your request was not submitted, please retry"

  Scenario: Transaction submission - Response timeout
    Given I have a balance
    Given I am logged in
    And the transaction submission request will timeout
    And I navigate to the page "TransactionFormPage"
    And I fill all transaction form data correctly
    And I tap the "transactionFormSendButton" button
    Then I expect the "errorWidgetDetails" to be "Looks like you are not connected to the Internet, please check your connection and try again."

  Scenario: Transaction submission - Connection timeout
    Given I have a balance
    Given I am logged in
    And I navigate to the page "TransactionFormPage"
    And I fill all transaction form data correctly
    And the service is unavailable
    And I tap the "transactionFormSendButton" button
    Then I expect the "errorWidgetDetails" to be "Looks like you are not connected to the Internet, please check your connection and try again."

  Scenario: Transaction submission close button
    Given I have a balance
    Given I am logged in
    And I navigate to the page "TransactionFormPage"
    When I tap the "backButton" button
    Then I am on the page "WalletPage"

  Scenario: Transaction success close button
    Given I have a balance
    Given I am logged in
    And I navigate to the page "TransactionSuccessPage"
    When I tap the "backButton" button
    Then I am on the page "WalletPage"
