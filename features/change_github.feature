Feature: Fundraiser can change the GitHub repository linked to a project
  Scenario: A project not holding tips changes github repository
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
      | abc    | 4.95   |
      | 333    | 4.9005 |

    When the project GitHub name is "baz/foo"
    And the commits on GitHub for project "baz/foo" are
      | sha | author | email              |
      | aaa | bob    | bobby@example.com  |
      | bbb | alice  | alicia@example.com |
      | ccc | bob    | bobby@example.com  |
    And the project tips are built from commits
    Then the project should have these tips:
      | commit | amount     |
      | 123    | 5.0        |
      | abc    | 4.95       |
      | 333    | 4.9005     |
      | aaa    | 4.851495   |
      | bbb    | 4.80298005 |
      | ccc    | 4.75495025 |

