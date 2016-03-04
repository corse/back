# clients table
class CreateClients < ActiveRecord::Migration[5.0]
  def change
    create_table :clients do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :password_digest, null: true
      t.string :cid, null: false
      t.string :secret, null: false
      t.string :scopes, null: false, default: ''
      t.timestamps

      ## Confirmable
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
    end
    add_index :clients, :cid, unique: true
    add_index :clients, :email, unique: true
    add_index :clients, :name, unique: true
  end
end
