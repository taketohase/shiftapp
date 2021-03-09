class RenameUserIdColumnToEntries < ActiveRecord::Migration[5.2]
  def change
    rename_column :entries, :user_id, :worker_id
  end
end
