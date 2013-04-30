class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string :first_name
      t.string :last_name
      t.string :designation
      t.string :region
      t.boolean :active
      t.integer :balance

      t.timestamps
    end
  end
end
