Feature: open swaggerui dogu landing page

  Scenario: The swaggerui dogu is accessed in browser
    When the swaggerui dogu is visited
    Then the page is shown without requiring authentication
    And the warp menu exists