Feature: This feature includes test scenarios for Store endpoint in SwaggerUI example...

  Background:
    * url baseUrl
    * path 'store'

  Scenario: Getting Store Inventory
    Given path 'inventory'
    When method GET
    Then status 200
    And match response == '#present'
    And match response.available == '#number'

  Scenario: Posting an order
    * def requestBody =
    """
    {
      "id": 3,
      "petId": 19,
      "quantity": 1,
      "shipDate": "2024-08-21T08:59:10.605Z",
      "status": "placed",
      "complete": true
    }
    """
    * karate.call('../callables/opsForOrder.feature@post', {requestMsg: requestBody, expectedStatus: 200})

  Scenario: Getting an order
    * karate.call('../callables/opsForOrder.feature@get', {orderId: 3, expectedStatus: 200})

  Scenario: Deleting an order
    * karate.call('../callables/opsForOrder.feature@delete', {orderId: 3, expectedStatus: 200})

  Scenario: Chain test with User, Pet, Store
    * def users = read('classpath:resources/inputUsers.json')
    * def user = get[0] users[?(@.username == 'emilybrown')]
    * karate.call('../callables/opsForUser.feature@post', {requestMsg: user, expectedStatus: 200})
    * karate.call('../callables/opsForUser.feature@login', {username: user.username, password: user.password, expectedStatus: 200})
    * def pet = karate.filter(read('classpath:resources/inputPets.json'), function(aPet){return aPet.category.name == 'Bird'})[0]
    * karate.call('../callables/opsForPet.feature@post', {requestMsg: pet, expectedStatus: 200})
    * def order =
      """
        {
          "id": 3,
          "petId": #(pet.id),
          "quantity": 1,
          "shipDate": "2024-08-23T08:59:10.605Z",
          "status": "placed",
          "complete": true
        }
      """
    * karate.call('../callables/opsForOrder.feature@post', {requestMsg: order, expectedStatus: 200})
    * karate.call('../callables/opsForOrder.feature@get', {orderId: order.id, expectedStatus: 200})
    * karate.call('../callables/opsForOrder.feature@delete', {orderId: order.id, expectedStatus: 200})
    * karate.call('../callables/opsForUser.feature@logout', {expectedStatus: 200})

