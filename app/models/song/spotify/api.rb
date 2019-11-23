class Song::Spotify::Api

  $spotify_api_setup = false

  def self.search(query, limit)
    setup_api
    tracks = RSpotify::Track.search(query, limit: limit)
    songs = tracks.map do |track|
      Song::Spotify.new(song_id: track.id,
                        title: track.name,
                        album: track.album.name,
                        artist: track.artists.map(&:name).join(', '),
                        duration: track.duration_ms,
                        cover_url: track.album.images.first['url']
                       )
    end
  end

  def self.find_attributes_by_id(id)
    setup_api
    track = RSpotify::Track.find(id)
    {
      title: track.name,
      album: track.album.name,
      artist: track.artists.map(&:name).join(', '),
      duration: track.duration_ms,
      cover_url: track.album.images.first['url'],
    }
  end

  def self.get_playlist(id, user)
    setup_api
    playlist = RSpotify::Playlist.find(user, id)
    playlist.tracks.map do |track|
      {
        song_id: track.id,
        title: track.name,
        album: track.album.name,
        artist: track.artists.map(&:name).join(', '),
        duration: track.duration_ms,
        cover_url: track.album.images.first['url'],
      }
    end
  end

  def self.setup_api
    unless $spotify_api_setup
      RSpotify.authenticate(Rails.application.credentials.spotify_client_id, Rails.application.credentials.spotify_client_secret)
      $spotify_api_setup = true
    end
  end

end
