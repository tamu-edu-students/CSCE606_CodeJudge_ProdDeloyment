Feature: Test the user rating table
  Background: 
    Given the instructor has access to ratings page
    
  Scenario: Verify the student ratings
    Given the instructor is on rating page
    Then the table should have the following contents
    When the instructor clicks on the username in the table
    Then the instructor should be redirected to the student details page
    