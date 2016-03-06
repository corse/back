# Assignment Solutions Table
class CreateSolutions < ActiveRecord::Migration[5.0]
  def change
    create_table :solutions do |t|
      t.references :assignment
      t.references :account
      t.text :content
      t.integer :grade, default: 0
      t.datetime :submit_at

      t.timestamps
    end
  end
end
