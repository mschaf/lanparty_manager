@javascript
Feature: Games

  Scenario: Crud Games as admin
    Given there is a setting with the games top text "### Welcome"
    Given I am signed in as an admin

    When I am on the games page
    Then I should see "Games"
      And I should see "Welcome" within "h3"

    When I follow "Add Game"
    Then I should see "Create Game"

    When I press "Create Game"
    Then the "Name" field should have an error

    When I fill in "Name" with "CS:GO"
      And I fill in "Description" with "A meaningful description for CS:GO"
      And I attach the file "features/sample_files/sample_cover.jpg" to "Cover image"
      And I press "Create Game"
    Then I should see in this order:
        """
        Games
        CS:GO                 edit - delete
        A meaningful description for CS:GO
        """
      And I should see an element for "img.game--cover-image"
    When I follow "edit"
    Then I should see "Edit CS:GO"
      And the "Name" field should contain "CS:GO"
      And I should see an element for "img"

    When I fill in "Name" with "CSGO"
      And I check "Remove cover image"
      And I press "Save Game"
    Then I should see in this order:
        """
        Games
        CSGO                 edit - delete
        A meaningful description for CS:GO
        """
      And I should not see an element for "img.game--cover-image"

    When I follow "edit"
    Then I should not see an element for "img"

    When I fill in "Name" with "CSS"
      And I follow "cancel"
    Then I should not see "CSS"
    But should see "CSGO"

    When I follow "delete"
      And I confirm the browser dialog
    Then I should not see "CSGO"


  Scenario: The description supports markdown
    Given I am signed in as an admin
      And I am on the new game page

    When I fill in "Name" with "Test Game"
      And I fill in "Description" with:
        """
        ###Title
        Some test

        - Some
        - bullet
        - points
        """
      And I press "Create Game"
    Then I should see in this order:
    """
      Title
      Some test

      Some
      bullet
      points
    """
      And I should see "Title" within "h3"
      And I should see "Some" within "ul > li:nth-of-type(1)"
      And I should see "bullet" within "ul > li:nth-of-type(2)"


  Scenario: Normal users dont see edit buttons
    Given there is a game
    Given I am signed in

    When I am on the games page
    Then I should not see "Add Game"
      And I should not see "edit"
      And I should not see "delete"

