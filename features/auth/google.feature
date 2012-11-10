Feature: Sing in google
  Scenario: Use google mail for registration
    When I click google icon, Site redirect me into google openID app
    And I Confirmed the app
    Then I am site user because google give me email