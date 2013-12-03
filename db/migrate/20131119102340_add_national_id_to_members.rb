class AddNationalIdToMembers < ActiveRecord::Migration
  def change
    add_column :members, :nationalid, :string
  end
end
