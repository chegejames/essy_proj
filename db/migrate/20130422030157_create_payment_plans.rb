class CreatePaymentPlans < ActiveRecord::Migration
  def change
    create_table :payment_plans do |t|
      t.integer :Judge
      t.integer :Magistrate
      t.integer :Kadhi

      t.timestamps
    end
  end
end
