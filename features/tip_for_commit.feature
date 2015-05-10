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
      | abc    | 4.95   |
      | 333    | 4.9005 |

    When the tipper is started
    Then these amounts should have been sent from the account of the project:
      | address                            | amount |
      | mxWfjaZJTNN5QKeZZYQ5HW3vgALFBsnuG1 | 9.9005 |

    And an email should have been sent to "alicia@example.com"
    When I click on the "Set your password and Primecoin address" link in the email
    And I fill "Password" with "password"
    And I fill "Password confirmation" with "password"
    And I fill "Primecoin address" with "mubmzLrtTgDE2WrHkiwSFKuTh2VTSXboYK"
    And I click on "Save"
    Then I should see "Information saved"
    And the user with email "alicia@example.com" should have "password" as password
    And the user with email "alicia@example.com" should have "mubmzLrtTgDE2WrHkiwSFKuTh2VTSXboYK" as peercoin address
    And the user with email "alicia@example.com" should have his email confirmed

    When the transaction history is cleared
    And the tipper is started
    Then these amounts should have been sent from the account of the project:
      | address                            | amount |
      | mubmzLrtTgDE2WrHkiwSFKuTh2VTSXboYK |   4.95 |

  Scenario: A project holding tips
    Given a project
    And the project holds tips
    And the project GitHub name is "foo/bar"
    And the commits on GitHub for project "foo/bar" are
      | sha |
      | 123 |
      | abc |
      | 333 |
    And our fee is "0"
    And a deposit of "500"

    When the project tips are built from commits
    Then the project should have these tips:
      | commit | amount |
      | 123    |        |
      | abc    |        |
      | 333    |        |

    When the tipper is started
    Then no coins should have been sent
