Feature: Creating a new problem
    An admin can create a new problem

Background:
    Given the admin has access

Scenario:
    Given the admin redirects to the problems page
    When they click on new problem button
    Then they should see a form for creating a new problem