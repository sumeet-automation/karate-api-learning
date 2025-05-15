Feature: sample karate test script
for help, see: https://github.com/karatelabs/karate/wiki/IDE-Support

  Background:
    * url 'https://reqres.in'

  #  Scenario: get all users and then get the first user by id
  #    Given path '/api/users'
  #    And path '2'
  #    When method get
  #    Then status 200
  #
  #  Scenario: create new user
  #    Given path '/api/users'
  #    And header x-api-key = 'reqres-free-v1'
  #    And request { "name": "morpheus", "job": "leader" }
  #    When method post
  #    Then status 201
  #    * def id = response.id
  #    And print 'id: ', id
  #    Given path '/api/users'
  #    And path id
  #    And header x-api-key = 'reqres-free-v1'
  #    When method get
  #    Then status 200
  #    And print 'response: ', response
  #    And match response.data.first_name == 'morpheus'

  #  Scenario: create new user with different load
  #    Given path '/api/users'
  #    And header x-api-key = 'reqres-free-v1'
  #    And request
  #    """
  #    {
  #      "name": "morpheus",
  #      "job": "leader"
  #    }
  #    """
  #    When method post
  #    Then status 201
  #    * def id = response.id
  #    And print 'id: ', id

  #
  #  Scenario: create new user with file
  #    Given path '/api/users'
  #    And header x-api-key = 'reqres-free-v1'
  #    * def requestLoad = read('classpath:examples/users/user.json')
  #    And request requestLoad
  #    When method post
  #    Then status 201
  #    * def id = response.id
  #    And print 'id: ', id

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
    And match $.job == 'leader'