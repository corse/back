# Course Assignment Table
class CreateAssignments < ActiveRecord::Migration[5.0]
  def change
    create_table :assignments do |t|
      t.string :title, null: false
      t.datetime :deadline
      t.text :content
      t.references :course

      t.timestamps
    end
  end
end
