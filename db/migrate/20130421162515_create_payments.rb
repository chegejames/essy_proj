class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.references :member
      t.integer :invoice
      t.string :mode_of_payment
      t.string :cheque_no
      t.string :bank_name
      t.integer :amount
      t.integer :total_amount
      t.integer :balance
      t.date :date

      t.timestamps
    end
    add_index :payments, :member_id
  end
end
