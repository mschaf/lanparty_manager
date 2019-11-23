class AddLockedToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :locked, :boolean
    add_column :users, :sign_up_ip, :string
    add_column :users, :last_sign_in_ip, :string
    add_column :users, :last_sign_in_at, :timestamp
  end
end
