Feature: A project collaborator distribute to commit authors
  @javascript
  Scenario:
    Given a project "a"
    And the project collaborators are:
      | seldon  |
      | daneel  |
    And our fee is "0"
    And a deposit of "500"
    And the last known commit is "AAA"
    And a new commit "BBB" with parent "AAA"
    And a new commit "CCC" with parent "BBB"
    And the author of commit "BBB" is "yugo"
    And the message of commit "BBB" is "Tiny change"
    And the author of commit "CCC" is "gaal"

    Given I'm logged in as "seldon"
    And I go to the project page
    And I click on "Edit project"
    And I uncheck "Automatically send 1% of the balance to each commit added to the default branch of the GitHub project"
    And I click on "Save"
    Then I should see "The project has been updated"

    When the new commits are read

    When I go to the project page
    And I click on "New distribution"
    And I select the commit recipients "Commits not rewarded"
    Then the distribution form should have these recipients:
      | recipient | reason                    | amount |
      | yugo      | Commit BBB: Tiny change   |        |
      | gaal      | Commit CCC: Some changes  |        |

    And I fill the amount to "yugo" with "0.5"
    And I remove the recipient "gaal"
    And I click on "Save"

    Then I should see these distribution lines:
      | recipient | reason                    | address                   | amount | percentage |
      | yugo      | Commit BBB: Tiny change   |                           |    0.5 |        100 |
    And I should see "Total amount: 0.50 XPM"
    When I click on "Send email request to provide an address"
    Then I should see "Request sent"
    And there should be 1 email sent
    And an email should have been sent to "yugo@example.com"

    When the new commits are read

    When I go to the project page
    And I click on "New distribution"
    And I select the commit recipients "Commits not rewarded"
    Then the distribution form should have these recipients:
      | recipient | reason                    | amount |
      | gaal      | Commit CCC: Some changes  |        |

  @javascript
  Scenario: Distribute to commits not linked to a GitHub account
    Given a project "a" holding tips
    And the project single collaborator is "seldon"
    And our fee is "0"
    And a deposit of "500"
    And the last known commit is "AAA"
    And a new commit "BBB" with parent "AAA"
    And the author of commit "BBB" is the non identified email "yugo@example.com"
    And the message of commit "BBB" is "Tiny change"

    Given I'm logged in as "seldon"
    When the new commits are read
    And I go to the project page
    And I click on "New distribution"
    And I select the commit recipients "Commits not rewarded"
    Then the distribution form should have these recipients:
      | recipient        | reason                    | amount |

  @javascript
  Scenario: Distribute to a single commit
    Given a project "a" holding tips
    And the project single collaborator is "seldon"
    And our fee is "0"
    And a deposit of "500"
    And the last known commit is "529a8eec77e455781eed81b0b2f351ec65d8eb95"
    And a new commit "170ed604f287b9fec397389d0b1b3f7d15b82276" with parent "529a8eec77e455781eed81b0b2f351ec65d8eb95"
    And a new commit "1329394df2595739d652528d48fe6db66c67e1e8" with parent "170ed604f287b9fec397389d0b1b3f7d15b82276"
    And the author of commit "170ed604f287b9fec397389d0b1b3f7d15b82276" is "yugo"
    And the message of commit "170ed604f287b9fec397389d0b1b3f7d15b82276" is "Tiny change"
    And the author of commit "1329394df2595739d652528d48fe6db66c67e1e8" is "gaal"

    Given I'm logged in as "seldon"
    When the new commits are read
    And I go to the project page
    And I click on "New distribution"
    And I add the commit "170ed604f287b9fec397389d0b1b3f7d15b82276" to the recipients
    Then the distribution form should have these recipients:
      | recipient | reason                           | amount |
      | yugo      | Commit 170ed604f2: Tiny change   |        |
    When I add the commit "1329394df" to the recipients
    Then the distribution form should have these recipients:
      | recipient | reason                           | amount |
      | yugo      | Commit 170ed604f2: Tiny change   |        |
      | gaal      | Commit 1329394df2: Some changes  |        |

    And I fill the amount to "yugo" with "0.5"
    And I click on "Save"

    Then I should see these distribution lines:
      | recipient | reason                           | address                   | amount    | percentage |
      | yugo      | Commit 170ed604f2: Tiny change   |                           |       0.5 |            |
      | gaal      | Commit 1329394df2: Some changes  |                           | Undecided |            |
