# Rename Accounts.user_id to Accounts.uid
class RenameUserIdToUid < ActiveRecord::Migration[5.0]
  def change
    rename_column :accounts, :user_id, :uid
  end
end
