Feature: An user can create a project, linked with GitHub or not.
  Scenario: Create a project simple project
    Given I'm logged in on GitHub as "seldon"

    When I visit the home page
    And I click on "Create a project"
    And I click on "Sign in with Github"
    Then I should see "New project"

    When I fill "Name" with "Project Foo"
    And I fill "Description" with "The foo project"
    And I click on "Save"
    Then I should see "The project was created"
    And there should be a project "Project Foo"
    And the description of the project should be
      """
      The foo project
      """
    And the project should hold tips
    And the project single collaborators should be "seldon"
    And the project address label should be "prime4commit-1"
    And the project donation address should be the same as account "prime4commit-1"
    And I should be on the project page

  Scenario: Create a project without name
    Given I'm logged in on GitHub as "seldon"

    When I visit the home page
    And I click on "Create a project"
    And I click on "Sign in with Github"
    Then I should see "New project"

    And I click on "Save"
    Then I should see "Please fix"
    And there should be no project

  Scenario: Create a project without name
    Given I'm logged in on GitHub as "seldon"

    When I visit the home page
    And I click on "Create a project"
    And I click on "Sign in with Github"
    Then I should see "New project"

    And I click on "Save"
    Then I should see "Please fix"
    And there should be no project

  Scenario: Create a project linked to a GitHub project
    Given I'm logged in on GitHub as "seldon"

    When I visit the home page
    And I click on "Create a project"
    And I click on "Sign in with Github"
    Then I should see "New project"

    When I fill "Name" with "Project Foo"
    And I fill "Description" with "The foo project"
    And I fill "GitHub URL" with "http://github.com/sigmike/prime4commit"
    And I click on "Save"
    Then I should see "The project was created"
    And there should be a project "Project Foo"
    And the GitHub name of the project should be "sigmike/prime4commit"
    And the project should hold tips
    And the project single collaborators should be "seldon"

  Scenario: Create multiple projects linked to the same GitHub project
    Given I'm logged in on GitHub as "seldon"

    When I visit the home page
    And I click on "Create a project"
    And I click on "Sign in with Github"
    Then I should see "New project"

    When I fill "Name" with "Project Foo"
    And I fill "Description" with "The foo project"
    And I fill "GitHub URL" with "http://github.com/sigmike/prime4commit"
    And I click on "Save"
    Then I should see "The project was created"

    When I visit the home page
    And I click on "Create a project"
    Then I should see "New project"

    When I fill "Name" with "Project Bar"
    And I fill "Description" with "The bar project"
    And I fill "GitHub URL" with "http://github.com/sigmike/prime4commit"
    And I click on "Save"
    Then I should see "The project was created"

  Scenario: Create a project as an email user
    When I visit the home page
    And I click on "Create a project"
    And I click on "Sign up"
    And I fill "Email" with "bob@example.com"
    And I fill "Password" with "password"
    And I fill "Password confirmation" with "password"
    And I click on "Sign up"
    Then I should see "A message with a confirmation link has been sent to your email address"
    And an email should have been sent to "bob@example.com"
    When I click on the "Confirm my account" link in the email
    Then I should see "Your account was successfully confirmed"
    When I fill "Email" with "bob@example.com"
    And I fill "Password" with "password"
    And I click on "Sign in" in the sign in form
    Then I should see "Signed in successfully"
    When I click on "Create a project"
    Then I should see "New project"

    When I fill "Name" with "Project Foo"
    And I fill "Description" with "The foo project"
    And I click on "Save"
    Then I should see "The project was created"
    And there should be a project "Project Foo"
    And the description of the project should be
      """
      The foo project
      """
    And the project should hold tips
    And the project single collaborators should be "bob@example.com"
    And the project address label should be "prime4commit-1"
    And the project donation address should be the same as account "prime4commit-1"
    And I should be on the project page

