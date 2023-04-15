Feature: Creating a new class
    An instructor can create a new class

Background:
    Given the instructor has access

Scenario:
    Given the instructor redirects to the classes page
    When they click on new class button
    Then they should see a form for creating a new class