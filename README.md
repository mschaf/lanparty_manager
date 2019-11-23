# Lan Party Manager

This application is used to manage my lanparties, its totally overkill and requires a quite tech-/rails-savvy individual to run it.

Its main pourpose is to have a global music queue, where all playes can enqueue music in a controlled manner. You can search both YouTube and Spotify from within the app and add song from both sources to the queue. The music is then played from a music player deamon https://github.com/mschaf/lanparty_manager_player.

You can also manage a list of games, suppling information of how to install games, setup network shares or how to connect to servers.

### Development Setup

#### Setup Environment
```
bundle install 

# setup config/database.yml
rails db:create
rails db:migrate

# setup credentials
rails credentials:edit
# specify secrets:
    youtube_api_key: 
    spotify_client_id: 
    spotify_client_secret: 
    api_token: 

```

#### Running Tests
At the moment only cucumber integration tests are employed. Run with `cucumber`. Requires chrome and chromedriver to be setup.

To run in parallel and inside vnc use `geordi`:
```
# create test databases
rails parallel:create
# setup vnc for geordi
geordi vnc --setup

# to run tests
geordi test
```
