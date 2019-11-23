class Song < ApplicationRecord

  include RailsStateMachine::Model
  include ActionView::Helpers

  mount_uploader :cover_image, SongCoverImageUploader

  validates :title, :duration, :song_id, presence: true
  validates :song_id, uniqueness: { scope: [:type], conditions: -> { where(state: [STATE_QUEUE, STATE_PLAYING]) }, message: 'can´t queue the same song twice' }
  validate :only_one_song_is_playing
  validates :song_id, format: { with: /\A[a-zA-Z0-9_-]{11}\z/,  message: "youtube id invalid" }, if: -> { self.is_a? Song::Youtube }
  validates :song_id, format: { with: /\A[0-9A-Za-z]{22}\z/,  message: "spotify id invalid" }, if: -> { self.is_a? Song::Spotify }
  validates :duration, :numericality => { less_than: 10 * 60 * 1000, message: 'can´t queue songs longer than 10 minutes' }, unless: -> { Power.current.nil? || Power.current&.can_queue_long_songs }, on: :create
  validate :locked, on: :create
  attr_accessor :init_from_api
  validate :queue_limit, unless: -> { self.user.nil? || Power.current.nil? || Power.current&.can_queue_over_limit }, on: :create

  before_validation :set_attributes_form_api
  before_validation :save_cover, before: :create

  has_one :playback, autosave: false, dependent: :delete
  belongs_to :user, optional: true

  state_machine do
    state :queue, initial: true
    state :playing
    state :played

    event :play do
      transitions from: :queue, to: :playing
    end

    event :finish do
      transitions from: :playing, to: :played
    end
  end

  private

  def save_cover
    if Rails.env.test?
      self.cover_image = Rack::Test::UploadedFile.new(Rails.root.join('spec/support/sample_files/sample_song_cover.jpg'), 'image/jpeg')
    else
      if !cover_image.present? && cover_url.present?
        self.remote_cover_image_url = cover_url
      end
    end

  end

  def set_attributes_form_api
    raise NotImplementedError
  end

  def type_as_string
    'none'
  end

  def only_one_song_is_playing
    playing_song = Song.where(state: STATE_PLAYING).first
    if playing? && playing_song.present? && playing_song != self
      errors.add(:base, 'there can only be one song playing')
    end
  end

  def locked
    if self.user&.locked?
      errors.add(:user, 'your account is locked')
    end
    if Setting.get_or_initialize.lock_queue && !Power.current&.can_queue_while_locked?
      errors.add(:user, 'the queue is currently locked')
    end
  end

  def queue_limit
    queued =  Song.where(state: [STATE_QUEUE], user: self.user)
    max_songs_in_queue = Setting.get_or_initialize.max_songs_queued_at_once
    if queued.count >= max_songs_in_queue
      errors.add(:user, "you can't queue more than #{pluralize(max_songs_in_queue, 'song')} at a time")
    end
  end

end
