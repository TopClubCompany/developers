Feature: Search
  Scenario: Empty query field
    Given submit find button
    When query field is empty
    And  the "Where" field is set
    Then user sees best match results sort by recommended