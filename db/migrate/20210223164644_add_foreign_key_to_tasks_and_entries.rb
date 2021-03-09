class AddForeignKeyToTasksAndEntries < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :tasks, :owners
    add_foreign_key :entries, :tasks
    add_foreign_key :entries, :workers
  end
end
