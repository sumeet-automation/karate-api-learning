Feature: Calling from another feature file

  @run
  Scenario: Fuzzy Mathces
    * def payload =
      """
      {
        "name": "sumeet",
        "job": "leader",
        "check": "value"
      }
      """