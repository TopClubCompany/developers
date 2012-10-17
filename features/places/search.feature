Feature: Search
   Scenario 1: Empty query field
     Given the query field is empty
      And the "Where" field is set
     When a user submit find button
     Then user sees best match results sort by recommended