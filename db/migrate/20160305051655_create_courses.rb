# Course Table
class CreateCourses < ActiveRecord::Migration[5.0]
  def change
    create_table :courses do |t|
      t.string :name, null: false
      t.integer :status, default: 0
      t.references :client, null: false

      t.timestamps
    end
  end
end
