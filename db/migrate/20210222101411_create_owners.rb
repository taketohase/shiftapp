class CreateOwners < ActiveRecord::Migration[5.2]
  def change
    create_table :owners do |t|
      t.string :name
      t.string :email
      t.string :userid
      t.string :password_digest

      t.timestamps
    end
  end
end
