class AddIsActiveToExchangesAndMarkets < ActiveRecord::Migration
  def change
    add_column :exchanges, :is_active, :boolean, default: true
    add_column :markets, :is_active, :boolean, default: true
  end
end
