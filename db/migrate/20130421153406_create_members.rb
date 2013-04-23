class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string :First_Name
      t.string :Last_Name
      t.string :Designation
      t.string :Email_Address
      t.string :Cell_Number
      t.string :Region
      t.boolean :active
      t.integer :balance

      t.timestamps
    end
  end
end
