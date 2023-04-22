Feature: Creating a new problem
    An instructor can create a new problem

Background:
    Given the instructor has access

Scenario:
    Given the instructor redirects to the problems page
    When they click on new problem button
    Then they should see a form for creating a new problem