class Setting < ApplicationRecord

  validate :there_is_only_one_setting
  validates :background_playlist, format: { with: /\A[0-9A-Za-z]{22}\z/,  message: "spotify id invalid" }, if: -> { self.background_playlist.present? }

  before_validation :format_playlist_id

  has_defaults max_songs_queued_at_once: 2, lock_sign_up: false, lock_queue: false, games_top_text: ''

  def self.get_or_initialize
    setting = Setting.first
    if setting
      setting
    else
      Setting.create
    end
  end

  private

  def there_is_only_one_setting
    setting = Setting.first
    unless setting.nil? || setting == self
      errors.add(:base, 'there can only be one setting')
    end
  end

  def format_playlist_id
    self.background_playlist&.sub!('spotify:playlist:', '')
  end

end
