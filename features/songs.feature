@javascript
Feature: Songs

  Scenario: See and queue songs as admin
    Given the apis are stubbed
      And there is a spotify song with the title "Crab Rave" and the state "playing"
      And there is a spotify song with the title "Narcotic" and the state "queue"
      And there is a youtube song with the title "Call of the mountain" and the state "queue"
      And I am signed in as an admin

    When I am on the songs page
    Then I should see in this order:
    """
    Music

    Currently Playing

    Crab Rave
    03:00 - Example Artist - Example Album

    Queue

    Narcotic
    03:00 - Example Artist - Example Album
    Call of the mountain
    03:00 - Youtube - Example Artist

    """

    When I fill in the music search field with "it doesnt matter because api will return the same everytime"
    Then I should see in this order:
    """
    Spotify:
    Master of Puppets
    08:37 - Metallica - Master of Puppets
    Enter Sandman

    Youtube:
    Ivan B - Sweaters
    02:28 - Youtube - BestModernMusic
    FiNCH ASOZiAL - ABFAHRT
    """

    When I click on "add" within ".music--search .song:nth-of-type(1)"
    Then I should see "Master of Puppets" within ".music--queue"

    When I click on "add" within ".music--search .song:nth-of-type(3)"
    Then I should see "Ivan B - Sweaters" within ".music--queue"

    When I click on "add" within ".music--search .song:nth-of-type(3)"
    Then I should see a danger flash
      And I should see "can´t queue the same song twice"

    When I click on "remove" within ".music--queue .song:nth-of-type(2)"
    Then I should see "Call of the mountain" within ".music--queue"


  Scenario: See and queue songs as user
    Given the apis are stubbed
      And there is a spotify song with the title "Crab Rave" and the state "playing"
      And there is a spotify song with the title "Narcotic" and the state "queue"
      And there is a youtube song with the title "Call of the mountain" and the state "queue"
      And I am signed in

    When I am on the songs page
    Then I should see in this order:
    """
    Music

    Currently Playing

    Crab Rave
    03:00 - Example Artist - Example Album

    Queue

    Narcotic
    03:00 - Example Artist - Example Album
    Call of the mountain
    03:00 - Youtube - Example Artist

    """
    But I should not see "remove"

    When I fill in the music search field with "it doesnt matter because api will return the same everytime"
    Then I should see in this order:
    """
    Spotify:
    Master of Puppets
    08:37 - Metallica - Master of Puppets
    Enter Sandman

    Youtube:
    Ivan B - Sweaters
    02:28 - Youtube - BestModernMusic
    FiNCH ASOZiAL - ABFAHRT
    """

    When I click on "add" within ".music--search .song:nth-of-type(1)"
    Then I should see "Master of Puppets" within ".music--queue"

    When I click on "add" within ".music--search .song:nth-of-type(3)"
    Then I should see "Ivan B - Sweaters" within ".music--queue"

    When I click on "add" within ".music--search .song:nth-of-type(3)"
    Then I should see a danger flash
    And I should see "can´t queue the same song twice"


  Scenario: See songs not logged in
    Given the apis are stubbed
      And there is a spotify song with the title "Crab Rave" and the state "playing"
      And there is a spotify song with the title "Narcotic" and the state "queue"
      And there is a youtube song with the title "Call of the mountain" and the state "queue"

    When I am on the songs page
    Then I should see in this order:
    """
    Music

    Currently Playing

    Crab Rave
    03:00 - Example Artist - Example Album

    Queue (sign in to add music to the queue)

    Narcotic
    03:00 - Example Artist - Example Album
    Call of the mountain
    03:00 - Youtube - Example Artist

    """
    But I should not see "remove"
      And I should not see "Music Search"


  Scenario: A locked user cant queue music
    Given the apis are stubbed
      And I am signed in
      And the user above is locked

    When I am on the songs page
      And I fill in the music search field with "it doesnt matter because api will return the same everytime"
      And I click on "add" within ".music--search .song:nth-of-type(1)"
    Then I should see a danger flash
      And I should see "your account is locked"


  Scenario: The queue is locked
    Given the apis are stubbed
      And there is a setting with the lock queue "true"
      And I am signed in

    When I am on the songs page
      And I fill in the music search field with "it doesnt matter because api will return the same everytime"
      And I click on "add" within ".music--search .song:nth-of-type(1)"
    Then I should see a danger flash
      And I should see "the queue is currently locked"


  Scenario: Users cant queue more songs than specified
    Given the apis are stubbed
      And there is a setting with the max songs queued at once "1"
      And I am signed in

    When I am on the songs page
      And I fill in the music search field with "it doesnt matter because api will return the same everytime"
      And I click on "add" within ".music--search .song:nth-of-type(1)"
    Then I should see "Master of Puppets" within ".music--queue"

    When I click on "add" within ".music--search .song:nth-of-type(2)"
    Then I should see a danger flash
      And I should see "you can't queue more than 1 song at a time"


  Scenario: Queue restrictions dont apply to admins
    Given the apis are stubbed
      And there is a setting with the lock queue "true" and the max songs queued at once "1"
      And I am signed in as an admin

    When I am on the songs page
      And I fill in the music search field with "it doesnt matter because api will return the same everytime"
      And I click on "add" within ".music--search .song:nth-of-type(1)"
    Then I should see "Master of Puppets" within ".music--queue"

    When I click on "add" within ".music--search .song:nth-of-type(3)"
    Then I should see "Ivan B - Sweaters" within ".music--queue"
