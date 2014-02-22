class CreateOrders < ActiveRecord::Migration
  def up
    create_table :orders do |t|
      t.string :type
      t.references :markets
      t.references :trades
      t.decimal :price
      t.decimal :amount
      t.integer :set

      t.timestamps
    end

    change_column :orders, :id, :integer, limit: 8
    add_index :orders, [:market_id, :exchange_id]
    add_index :orders, :exchange_id
  end

  def down
    drop_table :orders
  end
end
