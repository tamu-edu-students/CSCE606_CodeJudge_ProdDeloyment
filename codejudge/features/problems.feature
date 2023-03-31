Feature: View problems

  Scenario: View all problems
    Given there are some problems with different tags and difficulty levels
    When I am on the problems page
    Then I should see all the problems and their tags and difficulty levels

  Scenario: View all problems with a specific tag
    Given there are some problems with different tags and difficulty levels
    And there are some problems with a specific tag
    When I am on the problems page for the specific tag
    Then I should see all the problems with the specific tag and their tags and difficulty levels

  Scenario: View all problems with a specific difficulty level
    Given there are some problems with different tags and difficulty levels
    And there are some problems with a specific difficulty level
    When I am on the problems page for the specific difficulty level
    Then I should see all the problems with the specific difficulty level and their tags and difficulty levels

  Scenario: View all problems with a specific tag and difficulty level
    Given there are some problems with different tags and difficulty levels
    And there are some problems with a specific tag and difficulty level
    When I am on the problems page for the specific tag and difficulty level
    Then I should see all the problems with the specific tag and difficulty level and their tags and difficulty levels
