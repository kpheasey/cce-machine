class AddMarketToTicker < ActiveRecord::Migration
  def change
    add_column :tickers, :market_id, :integer
  end
end
