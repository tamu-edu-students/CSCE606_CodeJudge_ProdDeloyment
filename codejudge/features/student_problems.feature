Feature: Student able to redirect to problem page
    An student can see the list of problems to attempt

Background: 
    Given the student is authenticated

Scenario: 
    Given the student goes to the problems page
    When they click on problem name 
    Then they should see a problem page to attempt
    When they upload the solution file
    When they click on submit button
    Then they should see a solution page to attempt
    When they click on back to attempts
    Then they should go to attempts page
    Then they should find the problem in attempts page


