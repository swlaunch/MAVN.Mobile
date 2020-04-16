Feature: Onboarding
  Onboarding scenarios

  Scenario: I am redirected to WelcomePage when I tap Skip
    Given I am on the page "OnboardingPage"
    And I tap the "onboardingPageSkipButton" button
    Then I am on the page "WelcomePage"

  Scenario: I am redirected to WelcomePage when I tap Get Started
    Given I am on the page "OnboardingPage"
    And I go to the last onboarding page
    And I tap the "onboardingPageGetStartedButton" button
    Then I am on the page "WelcomePage"