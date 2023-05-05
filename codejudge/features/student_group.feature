Feature: Student able to join the group
    An student can join class group

Background: 
    Given the students are authenticated

Scenario: 
    Given the student goes to the groups page
    When they enter correct group code 
    Then they click on join class button
    Then they should able to join the group
    Then they able to see the classname in page
    When they enter incorrect group code 
    Then they click on joinclass button
    Then they should not able to join the group

    


