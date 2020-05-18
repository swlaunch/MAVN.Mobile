Feature: Lead Referral
  Lead Referral scenarios

  Scenario: CountryCodeWidget click opens CountryCodesListPage
    Given I am logged in
    And I navigate to the page "LeadReferralPage"
    When I tap the CountryCodeWidget
    Then I am on the page "CountryCodeListPage"

  Scenario: Selecting a code redirects back to LeadReferralPage
    Given I am logged in
    And I navigate to the page "LeadReferralPage"
    And I select a country code
    Then I am on the page "LeadReferralPage"


  Scenario: Clicking the close button redirects back to LeadReferralPage
    Given I am logged in
    And I navigate to the page "LeadReferralPage"
    And I tap the CountryCodeWidget
    And I am on the page "CountryCodeListPage"
    When I tap the "closeButton" button
    Then I am on the page "LeadReferralPage"

  Scenario: Successful lead referral submission
    Given I am logged in
    And I navigate to the page "LeadReferralPage"
    And lead referral submission will be successful
    And I fill all lead referral form data correctly
    And "submitButton" is scrolled into view
    When I tap the "submitButton" button
    Then I am on the page "LeadReferralSuccessPage"

  Scenario: Lead referral submission error
    Given I am logged in
    And I navigate to the page "LeadReferralPage"
    And lead referral submission will return an error
    And I fill all lead referral form data correctly
    And "submitButton" is scrolled into view
    When I tap the "submitButton" button
    Then I expect the "errorWidgetDetails" to be "Something went wrong, please try again"

  Scenario: Lead Referral submission - Response timeout
    Given I am logged in
    And the referral submission request will timeout
    And I navigate to the page "LeadReferralPage"
    And I fill all lead referral form data correctly
    And "submitButton" is scrolled into view
    And I tap the "submitButton" button
    Then I expect the "errorWidgetDetails" to be "Looks like you are not connected to the Internet, please check your connection and try again."

  Scenario: Lead Referral submission - Connection timeout
    Given I am logged in
    And I navigate to the page "LeadReferralPage"
    And I fill all lead referral form data correctly
    And "submitButton" is scrolled into view
    And the service is unavailable
    And I tap the "submitButton" button
    Then I expect the "errorWidgetDetails" to be "Looks like you are not connected to the Internet, please check your connection and try again."

  Scenario: Lead referral submission close button
    Given I am logged in
    And I navigate to the page "LeadReferralPage"
    When I tap the "backButton" button
    Then I am on the page "HomePage"

  Scenario: Lead referral submission success close button
    Given I am logged in
    And I navigate to the page "LeadReferralSuccessPage"
    When I tap the "backButton" button
    Then I am on the page "HomePage"

  Scenario: Lead referral submission success close button
    Given I am logged in
    And I navigate to the page "LeadReferralSuccessPage"
    When I tap the "formSuccessErrorButton" button
    Then I am on the page "ReferralListPage"