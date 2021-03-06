# Role based Authorization
class CreateRoles < ActiveRecord::Migration
  def change
    create_table(:roles) do |t|
      t.string :name, null: false
      t.references :resource, polymorphic: true

      t.timestamps
    end

    create_table(:users_roles, id: false) do |t|
      t.references :user, polymorphic: true
      t.references :role
    end

    add_index(:roles, :name)
    add_index(:roles, [:name, :resource_type, :resource_id])
    add_index(:users_roles, [:user_id, :role_id])
  end
end
