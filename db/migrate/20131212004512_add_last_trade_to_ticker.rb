class AddLastTradeToTicker < ActiveRecord::Migration
  def change
    add_column :tickers, :last_trade, :decimal
  end
end
