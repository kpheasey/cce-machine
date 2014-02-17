class RemoveSetFromOrders < ActiveRecord::Migration
  def up
    remove_column :orders, :set
  end

  def down
    add_column :orders, :set, :integer
  end
end
