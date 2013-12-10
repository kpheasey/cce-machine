class RenameMarketExchangeToExchangeMarket < ActiveRecord::Migration
  def change
    rename_table :market_exchanges, :exchange_markets
  end
end
