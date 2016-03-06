# Rename Profiles table to Account Table
class RenameProfilesToAccounts < ActiveRecord::Migration[5.0]
  def change
    rename_table :profiles, :accounts
  end
end
