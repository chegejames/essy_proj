class CreateBankAccounts < ActiveRecord::Migration
  def change
    create_table :bank_accounts do |t|
      t.string :bank_name
      t.string :account_name
      t.string :account_number
      t.string :beneficiary_branch

      t.timestamps
    end
  end
end
