class CreateRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :requests do |t|
      t.integer :owner_id
      t.integer :worker_id

      t.timestamps
    end
    add_foreign_key :requests, :owners
    add_foreign_key :requests, :workers
  end
end
