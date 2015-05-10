Feature: On projects not holding tips, a tip is created for each new commit
  Scenario: A project not holding tips
    Given a project
    And the project does not hold tips
    And the project GitHub name is "foo/bar"
    And the commits on GitHub for project "foo/bar" are
      | sha | author | email              |
      | 123 | bob    | bobby@example.com  |
      | abc | alice  | alicia@example.com |
      | 333 | bob    | bobby@example.com  |
    And our fee is "0"
    And a deposit of "500"
    Given a GitHub user "bob" who has set his address to "mxWfjaZJTNN5QKeZZYQ5HW3vgALFBsnuG1"

    When the project tips are built from commits
    Then the project should have these tips:
      | commit | amount |
      | 123    | 5.0    |
      | 333    | 4.95   |

    When the tipper is started
    Then these amounts should have been sent from the account of the project:
      | address                            | amount |
      | mxWfjaZJTNN5QKeZZYQ5HW3vgALFBsnuG1 | 9.95   |

    And no email should have been sent

  Scenario: A project holding tips
    Given a project
    And the project holds tips
    And the project GitHub name is "foo/bar"
    And the commits on GitHub for project "foo/bar" are
      | sha | author | email              |
      | 123 | bob    | bobby@example.com  |
      | abc | alice  | alicia@example.com |
      | 333 | bob    | bobby@example.com  |
    And our fee is "0"
    And a deposit of "500"
    And a GitHub user "bob" who has set his address to "mxWfjaZJTNN5QKeZZYQ5HW3vgALFBsnuG1"

    When the project tips are built from commits
    Then the project should have these tips:
      | commit | amount |
      | 123    |        |
      | 333    |        |

    When the tipper is started
    Then no coins should have been sent
