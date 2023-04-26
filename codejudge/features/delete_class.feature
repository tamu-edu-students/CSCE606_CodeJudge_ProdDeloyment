Feature: Delete the existing class
    An instructor can delete a existing class

Background:
    Given the Instructor has access

Scenario:
    Given the Instructor redirects to the classes page
    When they click on delete button
    Then they should see a new page for destroying a class
    Given the Instructor redirects to the destroy page
    When they click on edit this group
    Then they should see a edit page for editing the class
    When they click on Back to groups
    Then they should see a groups page
    When they click on destroy this group button
    Then they should see a classes table without deleted group
