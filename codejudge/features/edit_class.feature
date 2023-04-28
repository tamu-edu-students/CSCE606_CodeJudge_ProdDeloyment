Feature: Editing existing class details
    An instructor can edit existing class

Background:
    Given the instructor has access to edit existing class

Scenario:
    Given the instructor routes to classes page
    When they click on modify button
    Then they should see a form editing class details