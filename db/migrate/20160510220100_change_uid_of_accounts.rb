class ChangeUidOfAccounts < ActiveRecord::Migration[5.0]
  def change
    change_column :accounts, :uid, :string
    add_index(:accounts, :uid)
    add_index(:accounts, :client_id)
  end
end
