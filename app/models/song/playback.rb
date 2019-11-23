class Song::Playback < ApplicationRecord

  include RailsStateMachine::Model

  validate :there_is_only_one_playback

  before_validation :destroy_other_playbacks, on: :create, if: -> { Song::Playback.any? }
  before_create :set_song_to_next_in_queue
  before_create :set_song_to_a_random_song, unless: -> { song.present? }
  before_create :get_type_from_song

  before_create :set_song_to_playing

  before_destroy :set_song_to_played#, unless: -> { song.played? }

  belongs_to :song, optional: true
  validates_associated :song

  has_defaults current_time: 0

  state_machine do
    state :playing, initial: true
    state :paused
    state :skip

    event :pause do
      transitions from: :playing, to: :paused
    end

    event :resume do
      transitions from: :paused, to: :playing
    end

    event :skip do
      transitions from: :playing, to: :skip
      transitions from: :paused, to: :skip
    end
  end

  def there_is_only_one_playback
    playback = Song::Playback.first
    unless playback.nil? || playback == self
      errors.add(:base, 'there can only be one song playing')
    end
  end

  def song_must_be_in_queue
    unless self.song.queue?
      errors.add(:song, 'song must be in the queue')
    end
  end

  def set_song_to_next_in_queue
    self.song = Song.where(state: Song::STATE_QUEUE).order(:created_at).first
  end

  def set_song_to_a_random_song
    begin
    # TODO add setting for idle playlist id
      idle_playlist = Song::Spotify::Api.get_playlist(Setting.get_or_initialize.background_playlist, Setting.get_or_initialize.background_playlist_user)
      random_song_attributes = idle_playlist[rand(idle_playlist.length)]
      random_song = Song::Spotify.new(random_song_attributes)
      random_song.save!
      self.song = random_song
    rescue RestClient::NotFound
      raise BackgroundPlaylistNotFound
    end
  end

  def get_type_from_song
    self.playback_type = self.song.type_as_string
  end

  def set_song_to_playing
    self.song.play
  end

  def set_song_to_played
    self.song.finish
  end

  def destroy_other_playbacks
    Song::Playback.destroy_all
  end

end
