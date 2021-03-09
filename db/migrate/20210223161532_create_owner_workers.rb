class CreateOwnerWorkers < ActiveRecord::Migration[5.2]
  def change
    create_table :owner_workers do |t|
      t.integer :owner_id
      t.integer :worker_id

      t.timestamps
    end
    add_foreign_key :owner_workers, :owners
    add_foreign_key :owner_workers, :workers
  end
end
