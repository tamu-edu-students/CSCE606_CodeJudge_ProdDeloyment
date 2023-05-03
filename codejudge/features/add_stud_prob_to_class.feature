#Iteration-5 Spring-2023
Feature: Add problems and students to the existing class
    An instructor can add problems and students to a existing class

Background:
    Given the Instructor has access for class

Scenario:
    Given the Instructor Redirects to the classes page
    When they click on class code
    Then they should see a new page for the class details
    When they click on add problems
    Then they should see a new page for adding the problems to the class
    When they click on add students
    Then they should see a new page for adding the students to the class

