Feature: Instructor is able to view professor view
    An Instructor can add a class

Background:
    Given the Instructor is authenticated

Scenario: Add
    Given Instructor is on professors view
    Then they should see a list of classes
    
