class AddBackgroundPlaylistIdToSettings < ActiveRecord::Migration[5.2]
  def up
    add_column :settings, :background_playlist_user, :string
    add_column :settings, :background_playlist, :string
  end
end
