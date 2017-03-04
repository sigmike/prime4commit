Feature: A visitor can donate to a project
  Background:
    Given a project
    And our fee is "0.01"

  Scenario: A visitor sends coins to a project
    When I visit the project page
    And I click on "Donate"
    And I fill "Return address" with "mmGen7mZTGi9bciEaEa2W1DLsx3HjaFvcd"
    And I click on "Generate my donation address"
    Then I should see the project donation address associated with "mmGen7mZTGi9bciEaEa2W1DLsx3HjaFvcd"

    Given there's a new incoming transaction of "50" to the donation address associated with "mmGen7mZTGi9bciEaEa2W1DLsx3HjaFvcd"
    And the project balance is updated

    When I visit the project page
    Then I should see the project balance is "49.5"

    When I click on "List of donors"
    Then I should see the donor "mmGen7mZTGi9bciEaEa2W1DLsx3HjaFvcd" sent "50"

  Scenario: Sending twice with the same return address
    Given the project has a donation address "mfbDMySWmo4p31waWE4bUGFqK47V4comdq" associated with "mpbkNzunFtBmu3JYENE62UTLtKyvwrSUfx"
    When I visit the project page
    And I click on "Donate"
    And I fill "Return address" with "mpbkNzunFtBmu3JYENE62UTLtKyvwrSUfx"
    And I click on "Generate my donation address"
    Then I should see "mfbDMySWmo4p31waWE4bUGFqK47V4comdq"

  Scenario: Sending with an invalid return address
    When I visit the project page
    And I click on "Donate"
    And I click on "Generate my donation address"
    Then I should see "can't be blank"
    When I fill "Return address" with "mpbkNzunFtBmu3JYENE62UTLtKyvwrSUfy"
    And I click on "Generate my donation address"
    Then I should see "invalid"

  Scenario: Sending without a return address
    When I visit the project page
    And I click on "Donate"
    Then I should see the project donation address

    Given there's a new incoming transaction of "50" to the project donation address
    And the project balance is updated

    When I visit the project page
    Then I should see the project balance is "49.5"

    When I click on "List of donors"
    Then I should see the donor "No address provided" sent "50"

  Scenario: Multiple donations in a single transaction
    Given a project "A" with a donation address "mpD1oHHQqAWWrrfxzAg1gEWbHh2teQjYsU" associated with "mpR1otQoiJo8dfXzxyTmvPLg42n7RFJMMh"
    And a project "B" with a donation address "mpD2oDRevAtG5Q24jRQx1GKpaZfxM8wh3y" associated with "mpR1otQoiJo8dfXzxyTmvPLg42n7RFJMMh"
    And there's a new incoming transaction of "50" to "mpD1oHHQqAWWrrfxzAg1gEWbHh2teQjYsU" in transaction "tx1"
    And there's a new incoming transaction of "75" to "mpD2oDRevAtG5Q24jRQx1GKpaZfxM8wh3y" in transaction "tx1"
    And the project balances are updated

    When I visit the project "A" page
    Then I should see the project balance is "49.50"

    When I click on "List of donors"
    Then I should see the donor "mpR1otQoiJo8dfXzxyTmvPLg42n7RFJMMh" sent "50"

    When I visit the project "B" page
    Then I should see the project balance is "74.25"

    When I click on "List of donors"
    Then I should see the donor "mpR1otQoiJo8dfXzxyTmvPLg42n7RFJMMh" sent "75"
