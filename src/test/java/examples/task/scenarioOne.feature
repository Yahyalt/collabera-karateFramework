Feature: GoRest User API Testing

  Background:
    * url baseUrl
    * def authHeader = 'Bearer ' + token
    * header Accept = 'application/json'
      * def Holder = Java.type('examples.task.IdHolder')

  Scenario: Create employee, verify ID, then fetch by ID and verify status
    Given path 'users'
    And header Authorization = authHeader
    And header Accept = 'application/json'
    And request
      """
      {
        "name": "John Doe",
        "gender": "male",
        "email": "employee_" + Math.floor(Math.random() * 100000) + "@test.com",
        "status": "active"
      }
      """
    When method post
    Then status 201
    * print 'Full response:', response
    And match response.id == '#number'
    * Holder.id = response.id
    * print 'Successfully created employee with ID:', response.id

    Scenario: Fetch employee by ID and verify status
    * def userIdCreated = Holder.id
    Given path 'users', userIdCreated
    And header Authorization = authHeader
    When method get
    Then status 200
    And match response.id == userIdCreated
    And match response.status == '#regex ^(active|inactive)$'
    * print 'Successfully fetched employee with ID:', userIdCreated