Feature: Sing in twitter
  Scenario: Use twitter account for registration
    When I click twitter icon, Site redirect me into twitter app and I confirm this
    Then I must write my email for twitter auth
    And confirm the email for registration by twitter
    Then I am a site user because I give my email and confirm for email