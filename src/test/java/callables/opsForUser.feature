Feature: Logging in - Logging out - Posting Users...

  @post
  Scenario: Posting a user with parameter user, expectedStatus
    Given url baseUrl
    And path "user"
    * header Content-Type = "application/json"
    * request requestMsg
    When method POST
    Then match responseStatus == expectedStatus
    And match parseInt(response.message) == requestMsg.id

  @login
  Scenario: Logging in a user session with parameter username, password, expectedStatus
    Given url baseUrl
    And path 'user', 'login'
    And form field 'username' = username
    And form field 'password' = password
    When method GET
    Then match responseStatus == expectedStatus
    And match response.message == '#regex logged in user session:[0-9]+'

  @logout
  Scenario: Logging out a user session with parameter expectedStatus
    Given url baseUrl
    And path 'user', 'logout'
    When method GET
    Then match responseStatus == expectedStatus
    And match response.message == 'ok'