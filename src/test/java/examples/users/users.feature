Feature: sample karate test script
for help, see: https://github.com/karatelabs/karate/wiki/IDE-Support

  Background:
    * url baseUrl

  Scenario: get all users and then get the first user by id
    Given path '/api/users'
    And path '2'
    When method get
    Then status 200


  Scenario: get all users and then get the first user by id
    * set foo
      | path  | 0       | 1       |
      | bar   | 'baz'   | 'ban'   |
      | check | 'hello' | 'world' |
    And print 'foo: ', foo


  Scenario: create new user
    Given path '/api/users'
    And header x-api-key = 'reqres-free-v1'
    And request { "name": "morpheus", "job": "leader" }
    When method post
    Then status 201
    * def id = response.id
    And print 'id: ', id
    Given path '/api/users'
    And path id
    And header x-api-key = 'reqres-free-v1'
    When method get
    Then status 200
    And print 'response: ', response
    And match response.data.first_name == 'morpheus'

  Scenario: create new user with different load
    Given path '/api/users'
    And header x-api-key = 'reqres-free-v1'
    And request
      """
      {
        "name": "morpheus",
        "job": "leader"
      }
      """
    When method post
    Then status 201
    * def id = response.id
    And print 'id: ', id


  Scenario: create new user with file
    Given path '/api/users'
    And header x-api-key = 'reqres-free-v1'
    * def requestLoad = read('classpath:examples/users/user.json')
    And request requestLoad
    When method post
    Then status 201
    * def id = response.id
    And print 'id: ', id

  Scenario: create new user with random name
    * def randomWordGerator = Java.type("utility.RandomWordGenerator")
    * def randomName = randomWordGerator.generateWord(5)
    Given print 'name: ' + randomName
    Given path '/api/users'
    And header x-api-key = 'reqres-free-v1'
    And request
      """
      {
        "name": "#(randomName)",
        "job": "leader"
      }
      """
    When method post
    Then status 201
    And print response
    And match $.name == randomName
    And match karate.jsonPath(response,'$.job') == 'leader'
    And print 'myVarName: ', myVarName

  Scenario Outline: create new user with data driven
    Given path '/api/users'
    And header x-api-key = 'reqres-free-v1'
    * def name = "<name>"
    * def job = "#(job)"
    And request { "name": "<name>", "job": "<job>" }
    When method post
    Then status 201
    And print response
    And match response.name == '#string'
    And match response.id == '#string'
    And print __num , ' ',  __row
    Examples:
      | name     | job    | id |
      | morpheus | leader | 4  |
      | jason    | leader | 3  |

  Scenario Outline: create new user with data driven
    Given path '/api/users'
    And header x-api-key = 'reqres-free-v1'
    * def payload =
      """
      {
    "name": "#(name)",
    "job": ##(job)
    }
    """
    And request payload
    When method post
    Then status 201
    And print response
    And match response.name == '#string'
    And match response.id == '#string'
    And print __num , ' ',  __row
    Examples:
      | name  | job    | id |
      | jason | leader | 3  |
      | jason |        | 2  |


  Scenario Outline: create new user with data driven using json file
    Given path '/api/users'
    And header x-api-key = 'reqres-free-v1'
    * def payload =
      """
      {
        "name": "#(name)",
        "job": "#(job)"
      }
      """
    * configure logPrettyResponse = true
    And request payload
    When method post
    Then status 201
    And print response
    And match response.name == '#string'
    And match response.id == '#string'
    And print __num , ' ',  __row
    Examples:
      | read('user_data.json') |

  Scenario: Fuzzy Mathces
    * def payload =
      """
      {
        "name": "sumeet",
        "job": "leader",
        "check": "value"
      }
      """
    * match payload.check ==  '#present'
    * match payload == { name: '#string', job: '#notnull',  check: '#ignore' }

  @run
  Scenario: Calling from another feature file
    * call read('classpath:examples/users/CallingTest.feature')
    * print payload
    * match payload.check ==  '#present'
    * match payload == { name: '#string', job: '#notnull',  check: '#ignore' }
