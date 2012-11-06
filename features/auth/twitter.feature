Feature: Sing in twitter
  Scenario: Use twitter account for registration
    When I click twitter icon, Site redirect me into twitter app
    And I Confirmed the app
    Then I must write my email
    And confirm the email for registration
    Then I am a site user
  because I give my email and confirm for email