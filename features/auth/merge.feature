Feature: merge users
  Scenario: merge users with email
    When I sign_up in app from fb, and then from google with same email
    Then I have 2 accounts with providers [:google, :fb]
    And I register in app