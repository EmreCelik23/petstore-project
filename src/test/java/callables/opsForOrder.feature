Feature: Getting - Posting - Deleting an Order...

  @get
  Scenario: Getting an order with parameter orderId, expectedStatus
    Given url baseUrl
    And path 'store', 'order', orderId
    When method GET
    Then match responseStatus == expectedStatus
    And response.id == '#number'
    And response.petId == '#number'

  @post
  Scenario: Posting an order with parameter order, expectedStatus
    Given url baseUrl
    And path 'store', 'order'
    * header Content-Type = "application/json"
    * request requestMsg
    When method POST
    Then match responseStatus == expectedStatus
    And response.id == requestMsg.id
    And response.petId == requestMsg.petId
    And response.status == requestMsg.status

  @delete
  Scenario: Deleting an order with parameter orderId, expectedStatus
    Given url baseUrl
    And path 'store', 'order', orderId
    When method DELETE
    Then match responseStatus == expectedStatus
    And response.message = "" + expectedStatus