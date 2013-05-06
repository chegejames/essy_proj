class AddDeletedAtToMembers < ActiveRecord::Migration
  def change
    add_column :members, :deleted_at, :time
  end
end
