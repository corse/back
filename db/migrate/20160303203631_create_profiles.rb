# app users profile tables
class CreateProfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :profiles do |t|
      t.integer :client_id, null: false
      t.integer :user_id, null: false
      t.timestamps
    end
  end
end
