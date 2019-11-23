Feature: Sessions

  @javascript
  Scenario: User signs in and out
    Given there is a user with the name "alice", the password "123456" and the display_name "Alice"

    When I am on the signin page
      And I fill in "Username" with "bob"
      And I fill in "Password" with "123"
      And I press "Sign In"
    Then I should see "user not found"

    When I fill in "Username" with "alice"
      And I fill in "Password" with "123"
      And I press "Sign In"
    Then I should see "wrong password"

    When I fill in "Username" with "alice"
    When I fill in "Password" with "123456"
      And I press "Sign In"
    Then I should see a success flash
      And I should see "Alice" within the header

    When I follow "Sign out" within the header
    Then I should see a success flash
      And I should be on the signin page
