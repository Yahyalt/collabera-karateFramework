Feature: gorest users

  Background:
    * url baseUrl
    * header Authorization = 'Bearer ' + token

    @getAllUsers
  Scenario: get all users
    Given path 'users'
    When method get
    Then status 200
    And match response == '#[]'