Feature: Distribute funds to an user identifier

  @javascript
  Scenario:
    Given an user with email "bob@example.com"
    And the user with email "bob@example.com" has set his address to "mi9SLroAgc8eUNuLwnZmdyqWdShbNtvr3n"

    Given a project managed by "alice"
    And our fee is "0"
    And a deposit of "500"

    Given I'm logged in as "alice"
    And I go to the project page
    And I click on "New distribution"
    And I add the user with email "bob@example.com" through his identifier to the recipients
    And I fill the amount to "<bob@example.com identifier>" with "10"
    And I save the distribution

    Then I should see these distribution lines:
      | recipient                               | address                            | amount | percentage |
      | <bob@example.com identifier>            | mi9SLroAgc8eUNuLwnZmdyqWdShbNtvr3n |     10 |      100.0 |

    When I click on "Send the transaction"
    Then I should see "Transaction sent"
    And these amounts should have been sent from the account of the project:
      | address                            | amount |
      | mi9SLroAgc8eUNuLwnZmdyqWdShbNtvr3n |   10.0 |
    And the project balance should be "490.00"
