class AddDeletedAtToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :deleted_at, :time
  end
end
