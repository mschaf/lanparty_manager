class CreateUser < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :display_name
      t.string :password_digest
      t.string :remember_token
      t.boolean :name_locked
      t.boolean :admin

      t.timestamps
    end
    add_index :users, :name, unique: true
    add_index :users, :remember_token, unique: true

  end
end
