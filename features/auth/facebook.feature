Feature: Sing in facebook
  Scenario: Use Facebook account for registration
    Given I click facebook icon then Site redirect me into facebook app where i confirmed app
    Then I am site user because facebook give me email
    And I have nick_name, email, avatar
