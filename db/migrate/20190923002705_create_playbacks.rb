class CreatePlaybacks < ActiveRecord::Migration[5.2]
  def change
    create_table :song_playbacks do |t|
      t.references :song
      t.integer :current_time
      t.string :state
      t.string :playback_type

      t.timestamps
    end
  end
end
