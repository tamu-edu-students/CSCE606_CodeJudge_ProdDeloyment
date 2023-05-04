Feature: Test the user ranking table
  Background: 
    Given the instructor has access to ratings page
    
  Scenario: Verify the user ranking table contents
    Given I am on the user ranking page
    Then the table should have the following contents
    When I click on the username of the 3rd user in the table
    Then I should be redirected to the user details page of the 3rd user
    