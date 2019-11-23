class CreateSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :settings do |t|
      t.boolean :lock_sign_up
      t.boolean :lock_queue
      t.integer :max_songs_queued_at_once
      t.text :games_top_text

      t.timestamps
    end
  end
end
