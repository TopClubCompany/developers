Feature: Sing in facebook
  Scenario: Use Facebook account for registration
    When I click facebook icon, Site redirect me into facebook app
    And I Confirmed the app
    Then I am site user
    because facebook give me email
    And I have nick_name, email, avatar
