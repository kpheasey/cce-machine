class CreateTrades < ActiveRecord::Migration
  def up
    create_table :trades do |t|
      t.integer   :market_id
      t.integer   :exchange_id
      t.decimal   :price
      t.decimal   :amount
      t.integer   :exchange_trade_id, limit: 8
      t.datetime  :date
      t.timestamps
    end

    change_column :trades, :id, :integer, limit: 8
    add_index :trades, [:market_id, :exchange_id]
    add_index :trades, :exchange_id
  end

  def down
    drop_table :trades
  end
end
