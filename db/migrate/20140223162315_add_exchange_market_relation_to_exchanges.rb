class AddExchangeMarketRelationToExchanges < ActiveRecord::Migration
  def change
    add_column :exchanges, :exchange_market_id, :integer
  end
end
