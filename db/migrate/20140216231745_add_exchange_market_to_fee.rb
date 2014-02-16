class AddExchangeMarketToFee < ActiveRecord::Migration
  def up
    remove_column :fees, :market_id
    add_column :fees, :exchange_market_id, :integer
    add_index :fees, :exchange_market_id
  end

  def down
    remove_index :fees, :exchange_market_id
    remove_column :fees, :exchange_market_id
    add_column :fees, :market_id, :integer
  end
end
