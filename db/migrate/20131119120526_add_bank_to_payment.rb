class AddBankToPayment < ActiveRecord::Migration
  def change
    add_column :payments, :bank_account_id, :integer, references: :bank_accounts
    add_index :payments, :bank_account_id
  end
end
