class CreatePaymentPlans < ActiveRecord::Migration
  def change
    create_table :payment_plans do |t|
      t.integer :judge
      t.integer :magistrate
      t.integer :kadhi

      t.timestamps
    end
  end
end
