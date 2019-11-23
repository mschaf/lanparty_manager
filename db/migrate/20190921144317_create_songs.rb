class CreateSongs < ActiveRecord::Migration[5.2]
  def change
    create_table :songs do |t|
      t.string :title
      t.string :artist
      t.string :album
      t.string :song_id
      t.integer :duration
      t.string :state
      t.integer :queue_position
      t.references :user
      t.string :type
      t.string :cover_url
      t.jsonb :cover_image

      t.timestamps
    end
  end
end
