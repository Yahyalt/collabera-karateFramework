Feature: GoRest User API Testing

  Background:
    * url baseUrl
    * header Authorization = 'Bearer ' + token
    * header Accept = 'application/json'

  Scenario: Create a new employee and verify ID format
    Given path 'users'
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
    * print 'Successfully created employee with ID:', response.id
