Feature: This feature includes test scenarios for User endpoint in SwaggerUI example...

  Background:
    * url baseUrl
    * path 'user'
    * def requestBody =
      """
      {
      "id": 99,
      "username": "icardi9",
      "firstName": "Mauro",
      "lastName": "Icardi",
      "email": "mauroicardi@example.com",
      "password": "mauro123",
      "phone": "555-1234",
      "userStatus": 1
      }
      """

  Scenario: Posting a User
    * header Content-Type = "application/json"
    * request requestBody

    When method POST
    Then status 200
    And match parseInt(response.message) == requestBody.id

  Scenario: Getting a User
    Given path 'icardi9'
    When method GET
    Then status 200
    And match response.username == 'icardi9'
    And match response.id == '#number'
    And match response.email == '#regex ^[a-z]+@[a-z]+\.[a-z]+$'

  Scenario: Updating a User
    Given path 'icardi9'
    And set requestBody.password = 'hedef25'
    And request requestBody
    When method PUT
    Then status 200
    And response.message = '#present'

  Scenario: Deleting a User
    Given path 'icardi9'
    When method DELETE
    Then status 200
    And match response.message == requestBody.username

  Scenario: Creating Users with an array
    Given path 'createWithArray'
    * def usersArray = read('classpath:resources/inputUsers.json')
    * request usersArray
    When method POST
    Then status 200
    And response.message = 'ok'

  Scenario: Logging in a user session
    * def usersArray = read('classpath:resources/inputUsers.json')
    * karate.call('../callables/opsForUser.feature@login', {username: usersArray[0].username, password: usersArray[0].password}, expectedStatus: 200)

  Scenario: Logging out from a user session
    * karate.call('../callables/opsForUser.feature@logout', {expectedStatus: 200})