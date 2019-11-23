@javascript
Feature: Users

  Scenario: Sign Up
    Given there is a user with the name "alice"
      And I am on the new user page

    When I press "Sign Up"
    Then the "Username" field should have an error
      And the "Password" field should have an error
    And I should see in this order:
    """
    Username
    can't be blank, is too short (minimum is 3 characters)
    Password
    can't be blank
    """

    When I fill in "Username" with "alice"
      And I press "Sign Up"
    Then the "Username" field should have an error
      And I should see "has already been taken"

    When I fill in "Username" with "bob"
      And I fill in "Password" with "123456"
      And I press "Sign Up"
    Then the "Password confirmation" field should have an error
      And I should see "doesn't match Password"

    When I fill in "Username" with "bob"
      And I fill in "Password" with "123456"
      And I fill in "Password confirmation" with "123456"
    And I press "Sign Up"
    Then I should be on the signin page
      And I should see a success flash

  Scenario: RUD users as a admin
    Given there is a user with the name "alice" and the display name "Alice"
      And I am signed in as an admin

    When I click on "Users"
    Then I should see "Users" within ".title-bar"

    When I click on the first ".extendable--extend" element
    And I should see in this order:
      """
      Alice (alice)
      admin? false
      locked? false
      last sign in at
      last sign in ip
      sign up at
      sign up ip
      """

    When I click on the first "edit"
    Then I should see "Edit User"

    When I fill in "Display name" with "Bob"
      And I check "admin?"
      And I check "locked?"
      And I press "Save User"
    Then I should see a success flash
      And I should see in this order:
      """
      Bob (alice)
      admin? true
      locked? true
      """

    When I click on the first "delete"
      And I confirm the browser dialog
    Then I should not see "Bob"
      And I should see a success flash


  Scenario: There is no sign up button when its disabled
    Given there is a setting with the lock sign up "true"

    When I am on the signin page
    Then I should not see "No Account? Sign Up"
