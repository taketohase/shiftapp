class CreateEntries < ActiveRecord::Migration[5.2]
  def change
    create_table :entries do |t|
      t.integer :user_id
      t.integer :task_id
      t.date :day
      t.boolean :attendance, default: true, null: false
      t.integer :from_time_h
      t.integer :from_time_m
      t.integer :to_time_h
      t.integer :to_time_m

      t.timestamps
    end
  end
end
