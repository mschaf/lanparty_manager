@javascript
Feature: Settings

  Scenario: Edit Settings
    Given I am signed in as an admin

    When I click on "Settings"
    Then I should see "Edit Settings"
      And the "Lock sign up" checkbox should not be checked
      And the "Lock song queue" checkbox should not be checked
      And the "Max songs queued at once" field should contain "2"
      And the "Games top text" field should contain ""
      And the "Background playlist user" field should contain ""
      And the "Background playlist" field should contain ""

    When I check "Lock sign up"
      And I check "Lock song queue"
      And I fill in "Max songs queued at once" with "3"
      And I fill in "Games top text" with "Hello"
      And I fill in "Background playlist user" with "alice"
      And I fill in "Background playlist" with "aaaaaaaaaaaaaaaaaaaaaa"
      And I press "Save Settings"
    Then I should see a success flash

    When I go to the edit settings page
      And I wait for active ajax requests to finish
    Then the "Lock sign up" checkbox should be checked
      And the "Lock song queue" checkbox should be checked
      And the "Max songs queued at once" field should contain "3"
      And the "Games top text" field should contain "Hello"
      And the "Background playlist user" field should contain "alice"
      And the "Background playlist" field should contain "aaaaaaaaaaaaaaaaaaaaaa"
