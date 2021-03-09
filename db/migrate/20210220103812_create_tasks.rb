class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.integer :user_id
      t.string :title
      t.date :deadline
      t.date :from_date
      t.date :to_date
      t.text :comment

      t.timestamps
    end
  end
end
