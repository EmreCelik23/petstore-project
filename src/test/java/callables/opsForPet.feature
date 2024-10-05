Feature: Getting - Posting - Deleting a Pet...

  @get
  Scenario: Getting a pet with parameter petId, expectedStatus
    Given url baseUrl
    And path "pet", petId
    When method GET
    Then match responseStatus == expectedStatus
    And match response.id == '#number'
    And match response.category.id == '#number'
    And match response.category.name == '#string'
    And match response.name == '#string'
    And match response.photoUrls[0] == '#regex ^https://[a-z]+\.[a-z]+.*.jpg$'

  @post
  Scenario: Posting a pet with parameter pet, expectedStatus
    Given url baseUrl
    And path "pet"
    * header Content-Type = "application/json"
    * request requestMsg
    When method POST
    Then match responseStatus == expectedStatus
    And match response.id == requestMsg.id
    And match response.category.id == requestMsg.category.id
    And match response.category.name == requestMsg.category.name
    And match response.name == requestMsg.name
    And match response.photoUrls[0] == requestMsg.photoUrls[0]
    And match response.tags[0].id == requestMsg.tags[0].id
    And match response.tags[0].name == requestMsg.tags[0].name
    And match response.status == requestMsg.status
    And match response.status == requestMsg.status

  @delete
  Scenario: Deleting a pet
    Given url baseUrl
    And path "pet", petId
    When method DELETE
    Then match responseStatus == expectedStatus
    And response.id == petId