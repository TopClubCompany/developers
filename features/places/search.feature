Feature: Search
    Scenario 1: Empty query field
      Given the query field is empty
      And the "Where" field is set
      When a user submit find button
      Then user sees best match results sort by recommended

    Scenario 2: Not empty query field
      Given a user entered a query
      And the "Where" field is set
      When a user submit find button
      Then user sees best match results sort by recommended
      And appropriate category selected

    Scenario 3: Query matches category name
      Given a user entered a query that match category name
      When a user submit find button
      Then user sees best match results sort by recommended
      And matched category selected
      And related categories shown

    Scenario 4: "Where" field contain wrong city name
      Given a user trying to enter wrong a city, state, street name
      When a user entered few symbols
      Then user sees autocomplete tips