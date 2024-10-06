Feature: This feature file includes test cases for Pet endpoint in SwaggerUI example...

  Background:
    * url baseUrl
    * path "pet"

  Scenario: Creating a new pet
    * header Content-Type = "application/json"
    * def requestBody =
    """
{
  "id": 20,
  "category": {
    "id": 0,
    "name": "string"
  },
  "name": "Duman",
  "photoUrls": [
    "string"
  ],
  "tags": [
    {
      "id": 0,
      "name": "string"
    }
  ],
  "status": "sold"
}
    """
    And request requestBody
    When method POST
    Then print response
    And status 200
    And match response.id == '#number'
    And match response.name == requestBody.name

  Scenario: Getting Pets by ID
    Given path 20
    When method GET
    Then print "\n\nResponse: \n\n", response
    And status 200
    And match response.id == 20
    And match response.name == "Duman"

  Scenario: Trying to get a pet without a valid ID
    Given path 1010101
    When method GET
    Then status 404

  Scenario: Getting Pets by Status
    Given path "findByStatus"
    And param status = "sold"
    When method GET
    Then status 200
    #And print "\n\nResponse: \n\n", response

    * def controlFunc =
  """
    function(aResponse){
      karate.match(aResponse.name, '#string')
      karate.match(aResponse.id, '#present')
    }
  """
    And karate.map(response, controlFunc)

    Scenario: Updating Pets
      * header Content-Type = "application/json"
      * def update =
      """
      {
        "id": 20,
        "category": {
          "id": 0,
          "name": "string"
        },
        "name": "Buddy",
        "photoUrls": [
          "string"
        ],
        "tags": [
          {
            "id": 0,
            "name": "string"
          }
        ],
        "status": "available"
      }
      """
      And request update
      When method PUT
      Then status 200
      And match response.id == 20
      And match response.name == "Buddy"
      * print "\n\nResponse: \n\n", response


  Scenario: Deleting a Pet from Pet Store
    Given path 20
    When method DELETE
    Then status 200
    And response.id == 20


  Scenario Outline: Creating Pets from an external JSON file - <number>
    * header Content-Type = "application/json"
    * def requestBody = read('classpath:resources/inputPets.json')
    * def removeId = function(pet) { delete pet.id; return pet; }
    * def pet = removeId(requestBody[<number>])
    * request pet
    When method POST
    Then status 200
    And match response.id == '#number'
    And match response.category contains {"name":"#string"}

    Examples:
      | number |
      | 0      |
      | 1      |
      | 2      |
      | 3      |
      | 4      |

  Scenario: Creating Pets with creating JSON file - <number>
    * header Content-Type = "application/json"
    * def dataFaker = Java.type("net.datafaker.Faker")
    * def fakerObj = new dataFaker()

    * set pets
      | path          | 0                           | 1                           | 2                           | 3                           | 4                           |
      | id            | 100                         | 101                         | 102                         | 103                         | 104                         |
      | category.id   | 1                           | 2                           | 3                           | 4                           | 5                           |
      | category.name | fakerObj.animal().name()    | fakerObj.animal().name()    | fakerObj.animal().name()    | fakerObj.animal().name()    | fakerObj.animal().name()    |
      | name          | fakerObj.name().firstName() | fakerObj.name().firstName() | fakerObj.name().firstName() | fakerObj.name().firstName() | fakerObj.name().firstName() |
      | photoUrls[0]  | fakerObj.internet().url()   | fakerObj.internet().url()   | fakerObj.internet().url()   | fakerObj.internet().url()   | fakerObj.internet().url()   |
      | tags[0].id    | 1                           | 2                           | 3                           | 4                           | 5                           |
      | tags[0].name  | "important"                 | "not important"             | "important"                 | "important"                 | "not important"             |
      | status        | "avaliable"                 | "avaliable"                 | "avaliable"                 | "avaliable"                 | "avaliable"                 |

    * def results = []
    * def expected = [100, 101, 102, 103, 104]

    * def postFunc =
      """
        function(pet){
          response = karate.call("../callables/opsForPet.feature@post", {requestMsg: pet, expectedStatus: 200}).response
          results.push(response.id)
          }
      """

    When karate.forEach(pets, postFunc)

    Then match results == expected

  Scenario: Testing multiple feature files with a chain

    * def pets = read('classpath:resources/inputPets.json')
    * def postGetDeleteFunction =
    """
      function(pet){
        karate.call('../callables/opsForPet.feature@post', {requestMsg: pet, expectedStatus: 200})
        karate.call('../callables/opsForPet.feature@get', {petId: pet.id, expectedStatus: 200})
        karate.call('../callables/opsForPet.feature@delete', {petId: pet.id, expectedStatus: 200})
      }
    """

    * karate.forEach(pets, postGetDeleteFunction)
